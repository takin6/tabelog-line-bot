class ValidateReceivedMessagePolicy
  attr_reader :message
  def initialize(message)
    @message = message
  end

  def check
    message_params = []

    parse_message_result = parse_message(message)
    if validate_message_result.present?
      message_params = [{ message_type: "text", user: user, message: result }]
      # メッセージを格納するファイル作らなくちゃなー
      format_message = "以下のフォーマットに沿って教えてね⬇\n━━━━━━━━━━━━━━━━━\n場所\n食事タイプ（ランチ or ディナー）\n予算（ex. 下限~上限）\nレストランのジャンル（ex. 和食、フレンチ）\n用途（ex. デート、記念日、女子会）\nその他（ex. 個室あり、全席禁煙）\n━━━━━━━━━━━━━━━━━"
      message_params.push({ message_type: "text", user: user, message: format_message })

      return message_params
    end

    validate_message_result = validate_message(received_message)
    message_params = [{ message_type: "text", user: user, message: result }] if result.present?
    
    return message_params
  end

  private

  def parse_message
    error_message = ""
    base_message = "エラー❗️\n ━━━━━━━━━━━━━━━━\n"

    if message.split("\n").count != 6
      error_message += base_message
      error_message += "・フォーマットに沿って入力してください！"
    end

    return error_message
  end


  def validate_message
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
