module Workers
  class ReplyInstructionMessageBatch
    def execute(user_id)
      user = User.find(user_id)

      message_params = []
      message_params.push({ message_type: "text", user: user, message: "フォームを入力してレストランを検索しよう🍽"})
      message_params.push({ 
        message_type: "button",
        user: user, 
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

      user.reply_to_user(messages)
    end
  end
end