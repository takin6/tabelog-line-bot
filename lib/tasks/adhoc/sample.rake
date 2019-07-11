require 'csv'

namespace :adhoc do
  namespace :sample do
    desc "create flex_message_sample"
    task :flex_message_sample => :environment do
      File.open(Rails.root.join("lib", "tasks", "adhoc", "flex_message_sample.json"), 'w') do |file|
        example_hash = {:type=>"carousel", :contents=>[{:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/50164/150x150_square_50164694.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"樋口", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.39/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130601/13001215/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/80254/150x150_square_80254103.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"NARISAWA", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.38/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"60000円~79999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130603/13005423/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/82179/150x150_square_82179083.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"海味", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.33/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130603/13001179/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/78500/150x150_square_78500033.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"傳", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.33/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130603/13046855/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/78333/150x150_square_78333056.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"いち太", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.25/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130603/13176396/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/85583/150x150_square_85583628.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"天ぷら 元吉", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.19/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"15000円~19999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130603/13035758/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/79288/150x150_square_79288955.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"リストランテ 濱崎", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.17/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130602/13005340/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/84681/150x150_square_84681400.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"匠 進吾", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.17/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130603/13155925/"}}], :flex=>0}}, {:type=>"bubble", :hero=>{:type=>"image", :url=>"https://tblg.k-img.com/restaurant/images/Rvw/68995/150x150_square_68995636.jpg", :size=>"full", :aspectRatio=>"20:13", :aspectMode=>"cover"}, :body=>{:type=>"box", :layout=>"vertical", :contents=>[{:type=>"text", :text=>"フロリレージュ", :weight=>"bold", :size=>"lg"}, {:type=>"text", :text=>"⭐️評価4.1/5", :size=>"sm", :margin=>"md"}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"予算", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"20000円~29999円", :wrap=>true, :size=>"sm", :flex=>5}]}]}, {:type=>"box", :layout=>"vertical", :margin=>"lg", :spacing=>"sm", :contents=>[{:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"ジャンル", :color=>"#aaaaaa", :size=>"xs", :flex=>5}]}, {:type=>"box", :layout=>"baseline", :spacing=>"md", :contents=>[{:type=>"text", :text=>"フレンチ", :wrap=>true, :size=>"sm", :flex=>5}]}]}]}, :footer=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"separator", :margin=>"md"}, {:type=>"button", :style=>"link", :height=>"sm", :action=>{:type=>"uri", :label=>"👉レストランを予約する👈", :uri=>"https://tabelog.com/tokyo/A1306/A130601/13093814/"}}], :flex=>0}}, {:type=>"bubble", :body=>{:type=>"box", :layout=>"vertical", :spacing=>"sm", :contents=>[{:type=>"button", :flex=>1, :gravity=>"center", :action=>{:type=>"postback", :label=>"もっと見る", :data=>"mongo_restaurants_id=5d255a5c4cfad147dbe5aabe&pager=2"}}]}}]}
        file.puts(JSON.pretty_generate(example_hash))
      end
    end
  end
end



# def line_post_param
#   message_hotel = {
#     hotel: {
#       name: "hotel_name",
#     },
#     message_hotel_plan: {
#       room_name: "room_name"
#     }
#   }

#   {
#     "type": "flex",
#     "altText": "alt_text",
#     "contents": {
#       "type": "carousel",
#       "contents": (0..2).map do |i|
#         struct_contents(message_hotel)
#       end
#     }
#   }
# end

# def struct_contents(message_hotel)
#   hotel = message_hotel[:hotel]
#   {
#     "type": "bubble",
#     "hero": {
#       "type": "image",
#       "url": "https://mandai-shop.jp/takasaki/wp-content/uploads/2018/03/sample.jpg",
#       "size": "full",
#       "aspectRatio": "20:13",
#       "aspectMode": "cover"
#     },
#     "body": {
#       "type": "box",
#       "layout": "vertical",
#       "contents": struct_body_contents(message_hotel, hotel),
#     },
#     "footer": {
#       "type": "box",
#       "layout": "vertical",
#       "spacing": "sm",
#       "contents": struct_actions(message_hotel),
#       "flex": 0
#     }
#   }
# end

# def struct_body_contents(message_hotel, hotel)
#   result = []

#   result << {
#               "type": "text",
#               "text": hotel[:name],
#               "weight": "bold",
#               "size": "lg"
#             }

#   result << {
#               "type": "text",
#               "text": struct_price(message_hotel),
#               "weight": "bold",
#               "size": "sm"
#             }

#   # hotel_rank_value = Hotels::HotelRankValue.new(message_hotel.message_hotel_plan_hotel_rank)
#   # hotel_rating_value = Hotels::HotelRatingValue.new(message_hotel.message_hotel_plan_hotel_rating)
#   # hotel_reputation_value = Messengers::HotelCarousels::HotelReputationValue.new(hotel_rating_value, hotel_rank_value)
#   result << {
#               "type": "text",
#               "text": "hotel_reputation_value",
#               "size": "sm",
#               "margin": "md"
#             }
#   # end

#   result << {
#               "type": "box",
#               "layout": "vertical",
#               "margin": "lg",
#               "spacing": "sm",
#               "contents": struct_plan(message_hotel),
#             }

#   result << {
#               "type": "box",
#               "layout": "vertical",
#               "margin": "lg",
#               "spacing": "sm",
#               "contents": struct_recommended_sentences(message_hotel),
#             }

#   result
# end

# def struct_price(message_hotel)
#   # difference = message_hotel.total_price - self.minimum_hotel_price
#   return "差額4000円" 
# end

# def struct_plan(message_hotel)
#   message_hotel_plan = message_hotel[:message_hotel_plan]
#   [
#     {
#       "type": "box",
#       "layout": "baseline",
#       "spacing": "md",
#       "contents": [
#         {
#           "type": "text",
#           "text": "plan_title",
#           "color": "#aaaaaa",
#           "size": "xxs",
#           "flex": 5
#         }
#       ]
#     },
#     {
#       "type": "box",
#       "layout": "baseline",
#       "spacing": "md",
#       "contents": [
#         {
#           "type": "text",
#           "text": message_hotel_plan[:room_name],
#           "wrap": true,
#           "size": "sm",
#           "flex": 5
#         }
#       ]
#     },
#     {
#       "type": "box",
#       "layout": "baseline",
#       "spacing": "md",
#       "contents": [
#         {
#           "type": "text",
#           "text": "meal_type",
#           "wrap": true,
#           "size": "sm",
#           "flex": 5
#         }
#       ]
#     }
#   ]
# end

# def struct_recommended_sentences(message_hotel)
#   result =
#     [
#       {
#         "type": "box",
#         "layout": "baseline",
#         "spacing": "md",
#         "contents": [
#           {
#             "type": "text",
#             "text": "recommended_sentences",
#             "color": "#aaaaaa",
#             "size": "xxs",
#             "flex": 5
#           }
#         ]
#       }
#     ]

#   (0..2).each do |recommended_sentence|
#     sentence =
#       {
#         "type": "box",
#         "layout": "baseline",
#         "spacing": "md",
#         "contents": [
#           {
#             "type": "text",
#             "text": "hotel_recommended_sentence_value",
#             "wrap": true,
#             "size": "sm",
#             "flex": 5
#           }
#         ]
#       }

#     result << sentence
#   end

#   result
# end

# def struct_actions(message_hotel)
#   # actions = message_hotel.actions
#   [
#     {
#       "type": "separator",
#       "margin": "md"
#     },
#     {
#       "type": "button",
#       "style": "link",
#       "height": "sm",
#       "action": {
#         "type": "uri",
#         "label": "<text>",
#         "uri": "http://line.com"
#       },
#     },
#   ]
# end