module OmniauthCallbacks
  class LineUsecase
    attr_reader :omniauth
    def initialize(omniauth)
      @omniauth = omniauth
    end

    def execute
      display_name = omniauth.info["name"]
      profile_picture_url = omniauth.info["image"]
      line_id = omniauth["uid"]

      return find_or_create_user(line_id, profile_picture_url, display_name)
    end

    private

    def find_or_create_user(line_id, display_name, profile_picture_url)
      user = nil

      ActiveRecord::Base.transaction do
        user = User.find_by(line_id: line_id, name: display_name, profile_picture_url: profile_picture_url)

        unless user
          chat_unit = ChatUnit.create!(chat_type: :user)
          user = User.create!(chat_unit: chat_unit, line_id: line_id, name: display_name, profile_picture_url: profile_picture_url)
        end
      end

      return user
    end
  end
end