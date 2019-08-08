module SessionHelper

  def hold_session(user)
    session[:user_id] = user.id
  end

  def hold_chat_unit_to_session(chat_unit)
    session[:chat_unit_id] = chat_unit.id
  end

  def current_chat_unit
    @current_chat_unit ||= ChatUnit.find_by(id: session[:chat_unit_id])
  end

  def delete_chat_unit_from_session
    session.delete(:chat_unit_id)
    @current_chat_unit = nil
  end
end