module Messages
  class Restaurants < Message

    def create_associates(params)
      MessageRestaurant.create!(
        message: self,
        mongo_restaurants_id: params[:mongo_restaurants_id],
        pager: params[:pager]
      )
    end

    def line_post_param
      mongo_restaurants = Mongo::Restaurants.find(self.mongo_restaurants_id)
      from, to = Mongo::Restaurants.create_index(pager)
      selected_mongo_restaurants = mongo_restaurants.sort_restaurants_by_rating[from..to]

      {
        "type": "flex",
        "altText": "レストランのご紹介",
        "contents": {
          "type": "carousel",
          "contents": selected_mongo_restaurants.map do |restaurant|
            struct_restaurant(restaurant)
          end.push(see_more_contents)
        }
      }
    end

    private

    def struct_restaurant(restaurant)
      {
        "type": "bubble",
        "hero": {
          "type": "image",
          "url": restaurant[:thumbnail_image_url],
          "size": "full",
          "aspectRatio": "20:13",
          "aspectMode": "cover"
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": struct_body_blocks(restaurant),
        },
        "footer": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": struct_actions(restaurant[:redirect_url]),
          "flex": 0
        }
      }
    end

    def struct_body_blocks(restaurant)
      contents = []


      contents << {
        "type": "text",
        "text": restaurant[:name],
        "weight": "bold",
        "size": "lg"
      }

      contents << {
        "type": "text",
        "text": "⭐️評価#{restaurant[:rating]}/5",
        "size": "sm",
        "margin": "md"
      }

      contents << struct_budget_block(restaurant[:budget])

      contents << struct_genre_block(restaurant[:genre])

      return contents
    end

    def struct_budget_block(budget)
      lower_budget, upper_budget = budget
      {
        "type": "box",
        "layout": "vertical",
        "margin": "lg",
        "spacing": "sm",
        "contents": [
          {
            "type": "box",
            "layout": "baseline",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "予算",
                "color": "#aaaaaa",
                "size": "xs",
                "flex": 5
              }
            ]
          },
          {
            "type": "box",
            "layout": "baseline",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "#{lower_budget}円~#{upper_budget}円",
                "wrap": true,
                "size": "sm",
                "flex": 5
              }
            ]
          }
        ]
      }
    end

    def struct_genre_block(genre)
      {
        "type": "box",
        "layout": "vertical",
        "margin": "lg",
        "spacing": "sm",
        "contents": [
          {
            "type": "box",
            "layout": "baseline",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "ジャンル",
                "color": "#aaaaaa",
                "size": "xs",
                "flex": 5
              }
            ]
          },
          {
            "type": "box",
            "layout": "baseline",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "フレンチ",
                "wrap": true,
                "size": "sm",
                "flex": 5
              }
            ]
          }
        ]
      }
    end

    def struct_actions(redirect_url)
      [
        {
          "type": "separator",
          "margin": "md"
        },
        {
          "type": "button",
          "style": "link",
          "height": "sm",
          "action": {
            "type": "uri",
            "label": "👉レストランを予約する👈",
            "uri": redirect_url
          }
        }
      ]
    end

    def see_more_contents
      {
        "type": "bubble",
        "body": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "button",
              "flex": 1,
              "gravity": "center",
              "action": {
                "type": "postback",
                "label": "もっと見る",
                "data": "mongo_restaurants_id=#{self.mongo_restaurants_id}&pager=#{self.pager + 1}"
              }
            }
          ]
        }
      }
    end

  end
end