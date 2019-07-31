module Messages
  class Button < Message

    def create_associates(params)
      MessageButton.create!(
        message: self,
        thumbnail_image_url: params[:thumbnail_image_url],
        text: params[:text],
        actions: params[:actions]
      )
    end

    def line_post_param
      {
        type: "template",
        altText: "検索",
        template: {
          type: "buttons",
        　imageAspectRatio: "rectangle",
          text: self.message_button.text,
          thumbnailImageUrl: self.message_button.thumbnail_image_url,
          actions: self.message_button.actions
        }
      }
    end
  end
end
