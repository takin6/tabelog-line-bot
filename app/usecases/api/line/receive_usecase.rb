module Api
  module Line
    class ReceiveUsecase
      attr_reader :user

      def receive(request)
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        body = request.body.read
        client = Messenger::LineWrapper.new
        return ServiceResult.new(false, "validation signature failed") unless client.validate_signature(body, signature)

        execute(body, client)
      end

      private

      def execute(body, client)
        event = client.parse_events_from(body)[0]
        @user = find_or_create_user(event["source"], client)

        # 暫定ではメッセージ一つしか送信されない想定のためfactoryは作らない
        case event
        when ::Line::Bot::Event::Message
          case event.type
          when ::Line::Bot::Event::MessageType::Text
            received_message = event.message['text']
            # line apiとの最初の通信の時
            return ServiceResult.new(true) if received_message == "Hello, world" && Rails.env.development?

            Message.create_receive_message!({ message_type: "text", user: user, message: received_message  })

            result = parse_message(received_message)
            if result.present?
              message_params = [{ message_type: "text", user: user, message: result }]
              # メッセージを格納するファイル作らなくちゃなー
              format_message = "以下のフォーマットに沿って教えてね⬇\n━━━━━━━━━━━━━━━━━\n場所\n食事タイプ（ランチ or ディナー）\n予算（ex. 下限~上限）\nレストランのジャンル（ex. 和食、フレンチ）\n用途（ex. デート、記念日、女子会）\nその他（ex. 個室あり、全席禁煙）\n━━━━━━━━━━━━━━━━━"
              message_params.push({ message_type: "text", user: user, message: format_message })

              return reply_error_messages(message_params)
            end

            result = validate_message(received_message)
            if result.present?
              message_params = [{ message_type: "text", user: user, message: result }]
              return reply_error_messages(message_params)
            end

            search_history = SearchHistory.create_from_message(user.id, received_message)

            # other_requestsでも絞り込めるように
            SearchRestaurantWorker.perform_async user.id if Mongo::Restaurants.where(station_id: search_history.station_id).count == 0

            if Mongo::Restaurants.where(station_id: search_history.station_id).count == 0
              message_params = [{ message_type: "text", user: user, message: "レストランが一件も検索されませんでした。" }]
              return reply_error_messages(message_params)
            end

            Messenger::ReplyRestaurantsFlexMessageWorker.perform_async search_history.id
          else
            # 「フォーマットに従ってください」メッセージをリターンする
            return ServiceResult.new(false, "message type not text")
          end

           return ServiceResult.new(true)
        end
      when ::Line::Bot::Event::Postback
        Messenger::Line::PostbackWrapper.new(user, event)
      end

      def find_or_create_user(source, client)
        profile_response = client.get_profile(source['userId'])
        profile = JSON.parse(profile_response.body)
        user = User.find_or_create_by(line_id: source['userId'], name: profile['displayName'], profile_picture_url: profile['pictureUrl'])
        return user
      end

      def reply_error_messages(message_params)
        message_params.each do |param|
          message = Message.create_reply_message!(param)
          Messenger::ReplyErrorMessageWorker.perform_async(user.id, message.id)
        end

        return ServiceResult.new(true)
      end

      def parse_message(message)
        error_message = ""
        base_message = "エラー❗️\n ━━━━━━━━━━━━━━━━\n"

        if message.split("\n").count != 6
          error_message += base_message
          error_message += "・フォーマットに沿って入力してください！"
        end

        return error_message
      end


      def validate_message(message)
        # ISSUE: situation, other_hopeはこちらで絞っておく？？
        error_message = ""
        base_message = "エラー❗️\n ━━━━━━━━━━━━━━━━\n"

        location, meal_type, budget, meal_kind, situation, others = message.split("\n")

        # 曖昧検索を取り入れるかどうか。もしもなかった時に登録したい
        error_message += "・場所が見つかりませんでした！\n" if Station.find_by(name: location).nil?

        # meal_typeはdinnerか昼食か
        error_message += "・食事タイプはランチかディナーを入力してください！\n" unless ["ランチ", "ディナー"].include?(meal_type)
        
        # budgetのvalidation
        lower_budget, upper_budget = budget.split("~").map(&:to_i)
        error_message += "・予算を正しく入力してください！\n" unless lower_budget <= upper_budget

        error_message.insert(0, base_message) unless error_message == ""

        return error_message
      end

    end
  end
end
