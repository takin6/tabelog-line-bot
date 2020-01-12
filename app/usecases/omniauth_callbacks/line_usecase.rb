module OmniauthCallbacks
  class LineUsecase
    attr_reader :omniauth
    def initialize(omniauth)
      @omniauth = omniauth
    end

    def execute
      chat_unit = ChatUser.create_or_find_all_entities!({
        line_id: omniauth["uid"],
        name: omniauth.info["name"],
        profile_picture_url: omniauth.info["image"]
      })

      return chat_unit
    end
  end
end