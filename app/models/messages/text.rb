module Messages
  class Text < Message

    def create_associates(params)
      MessageText.create!(
        message: self,
        value: params[:message]
      )
    end

    def line_post_param
      {
        type: 'text',
        text: self.message_text_value
      }
    end
  end
end