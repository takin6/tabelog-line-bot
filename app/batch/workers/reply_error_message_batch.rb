module Workers
  class ReplyErrorMessageBatch
    def execute(user_id, message_id)
      user = User.find(user_id)
      message = Message.find(message_id)

      user.reply_to_user([message.cast])
    end
  end
end