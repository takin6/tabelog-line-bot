module Workers
  class ReplyFollowMessageBatch
    def execute(chat_unit_id)
      chat_unit = ChatUnit.find(chat_unit_id)
      # user = User.find(user_id)

      message_params = []
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "友だち追加ありがとうございます🎶\nティラミスで#{chat_unit.user.name}さんの行きたいお店を見つけましょう❗️" })
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "グループに招待してメンションしてくれれば，お友達とリアルタイムで行きたいレストランを決めらます♪"})
      message_params.push({ message_type: "text", chat_unit: chat_unit, message: "以下のフォームで希望を教えてください☺️"})
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

      messages = []
      ActiveRecord::Base.transaction do
        message_params.each do |param|
          messages.push(Message.create_reply_message!(param))
        end
      end

      chat_unit.reply_to_entity(messages)
      # user.reply_to_user(messages)
    end
  end
end