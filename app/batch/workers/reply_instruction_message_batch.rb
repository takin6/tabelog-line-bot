module Workers
  class ReplyInstructionMessageBatch
    def execute(chat_unit_id, is_initial_message)
      chat_unit = ChatUnit.find(chat_unit_id)

      message_params = []
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "トークグループへの招待ありがとうございます🎶\nティラミスで行きたいお店を見つけましょう❗️"}) if is_initial_message
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "トークルームへの招待ありがとうございます🎶\nティラミスで行きたいお店を見つけましょう❗️"}) if chat_unit.initial_message_to_room?
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "フォームを入力してレストランを検索‼️🍽"})
      # https://cdn.pixabay.com/photo/2015/12/08/17/40/magnifying-glass-1083378_1280.png
      # このイメージをリサイズしてs3にアップしたい。。
      # 何種類かの画像を用意しておいて、パターンをなくす?
      message_params.push({ 
        message_type: "button",
        chat_unit: chat_unit, 
        thumbnail_image_url: "https://images.unsplash.com/photo-1511282964533-7f0c3c1f555a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
        text: "検索フォーム",
        actions: [{
          type: "uri",
          label: "レストランを検索",
          uri: "https://line.me/R/app/" + LineLiff.find_by(name: "search_restaurants").liff_id
        }] 
      })
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "もしもお邪魔でしたら「ティラミス bye」とメッセージを送ってください。悲しいけど退出します。"}) if chat_unit.chat_type_room? || chat_unit.chat_type_group?

      messages = []
      ActiveRecord::Base.transaction do
        message_params.each do |param|
          messages.push(Message.create_reply_message!(param))
        end
      end

      chat_unit.reply_to_entity(messages)
    end
  end
end