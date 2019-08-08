module Messenger
  class LineWrapper
    attr_reader :client
    delegate :validate_signature,
             :parse_events_from, 
             :push_message, 
             :get_profile, 
             :create_rich_menu, 
             :create_rich_menu_image, 
             :set_default_rich_menu, 
             :get_room_member_profile, 
             :leave_room,
             :leave_group,
             to: :client

    def initialize
      @client ||= ::Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end

    def post_messages(user, messages)
      message_params = []
      messages.each do |message|
        Rails.logger.info "#{message.line_post_param}"
        message_params.push message.line_post_param
      end

      api_response = client.push_message(
        user.line_id,
        message_params
      )

      unless api_response.is_a?(Net::HTTPSuccess)
        raise "line api error"
      end

      ServiceResult.new(true)
    end
  end
end
