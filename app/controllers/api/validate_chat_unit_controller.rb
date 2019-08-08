module Api
  class ValidateChatUnitController < ActionController::API
    include SessionHelper

    def create
      chat_unit = find_chat_unit

      hold_chat_unit_to_session(chat_unit)
      unless current_chat_unit&.is_blocking
        head :ok
      else
        message = current_user ? "ブロックを解除してから検索してください" : "無効なセッションです"
        render json: { errors: message }, status: :bad_request
      end
    end

    private

    def validate_chat_unit_param
      params.require(:entity)
            .permit(
              user: %i[line_id name profile_picture_url],
              room: %i[line_id],
              group: %i[line_id]
            )
    end

    def find_chat_unit
      case chat_unit_kind
      when "user"
        user = User.find_by(
          line_id: validate_chat_unit_param[:user][:line_id],
          name: validate_chat_unit_param[:user][:name],
          profile_picture_url: validate_chat_unit_param[:user][:profile_picture_url]
        )
        chat_unit = user.chat_unit
      when "room"
        chat_unit = ChatRoom.create_or_find_all_entities!(validate_chat_unit_param[:room][:line_id], validate_chat_unit_param[:user])
      when "group"
        chat_unit = ChatGroup.create_or_find_all_entities!(validate_chat_unit_param[:group][:line_id], validate_chat_unit_param[:user])
      end

      return chat_unit
    end

    def chat_unit_kind
      if validate_chat_unit_param.dig(:room)&.dig(:line_id)
        return "room"
      elsif validate_chat_unit_param.dig(:group)&.dig(:line_id)
        return "group"
      else
        return "user"
      end
    end
  end
end