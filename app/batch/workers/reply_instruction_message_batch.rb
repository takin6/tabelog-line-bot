module Workers
  class ReplyInstructionMessageBatch
    def execute(chat_unit_id, is_initial_message)
      chat_unit = ChatUnit.find(chat_unit_id)

      message_params = []
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "トークグループへの招待ありがとうございます🎶\nティラミスで行きたいお店を見つけましょう❗️"}) if is_initial_message
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "トークルームへの招待ありがとうございます🎶\nティラミスで行きたいお店を見つけましょう❗️"}) if chat_unit.initial_message_to_room?
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "フォームを入力してレストランを検索‼️🍽"})
      message_params.push({ 
        message_type: "button",
        chat_unit: chat_unit, 
        thumbnail_image_url: "https://www.telegraph.co.uk/content/dam/Travel/Destinations/Asia/Japan/Tokyo/Tokyo---Restaurants---New-York-Grill.jpg?imwidth=450",
        text: "検索フォーム",
        actions: [{
          type: "uri",
          label: "レストランを検索",
          uri: "https://line.me/R/app/" + LineLiff.find_by(name: "search_restaurants").liff_id
        }] 
      })
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "もしもお邪魔でしたら「ティラミス bye」とメッセージを送ってください。悲しいけど退出します。"})

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