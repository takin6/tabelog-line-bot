class ValidateReceivedMessagePolicy
  attr_reader :user, :message
  def initialize(user, message)
    @user = user
    @message = message
  end

  def check
    message_params = []
    # 始めのトライ
    if message == "Hello, world"
      message_params = [{　message_type: "text", user: user, message: "first try" }]
      return message_params
    end

    message_params.push({ message_type: "text", user: user, message: "フォームを入力してレストランを検索しよう❗️" })
    message_params.push({ 
      message_type: "button",
      user: user, 
      thumbnail_image_url: "https://www.telegraph.co.uk/content/dam/Travel/Destinations/Asia/Japan/Tokyo/Tokyo---Restaurants---New-York-Grill.jpg?imwidth=450",
      text: "検索フォーム",
      actions: [{
        type: "uri",
        label: "レストランを検索",
        uri: struct_liff_uri
      }] 
    })
    
    return message_params
  end

  private

  def struct_liff_uri
    return "https://line.me/R/app/" + LineLiff.find_by(name: "search_restaurants").liff_id
  end
end
