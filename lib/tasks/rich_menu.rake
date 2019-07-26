require 'line/bot'

namespace :line_rich_menu do
  desc "line_rich_menuのgemを使って、リッチメニューの作成から既存ユーザーとの紐付けを行う"

  task :creates_default_menu => :environment do
    Constants::LINE_TYPE.keys.map do |line_type|
      client = Messenger::LineWrapper.new(line_type)

      rich_menu_image_file_path = 'app/assets/rich_menus/'.freeze

      rich_menu= {
        "size": {
          "width": 2500,
          "height": 1686
        },
        "selected": true,
        "name": "richmenu_before_reservation",
        "chatBarText": "メニュー",
        "areas": [
          {
            "bounds": {
              "x": 0,
              "y": 843,
              "width": 2500,
              "height": 843
            },
            "action": {
              "type": "uri",
              "uri": url ? LineUtil.add_line_param(url, line_type) : nil
            }
          },
          {
            "bounds": {
              "x": 0,
              "y": 0,
              "width": 2500,
              "height": 843
            },
            "action": {
              "type": "postback",
              "displayText": "使い方教えて！",
              "data": "action=question_form&detail=before_reservation"
            }
          }
        ]
      }
      response = client.create_rich_menu(rich_menu)
      hash = JSON.parse(response.body)
      rich_menu_id = hash['richMenuId']
      unless rich_menu_id
        p hash
        next
      end
      rich_menu_name = "richmenu_before_reservation"
      if old_rich_menu = LineRichmenu.find_by(line_type: line_type, name: rich_menu_name)
        old_rich_menu_id = old_rich_menu.rich_menu_id
        response = client.delete_rich_menu(old_rich_menu_id)
        p response.body
        old_rich_menu.update!(
          rich_menu_id: rich_menu_id
        )
      else
        LineRichmenu.create!(
          line_type: line_type,
          rich_menu_id: rich_menu_id,
          name: rich_menu_name
        )
      end
      image_name = "rich_menu_image_before_reservaiton.jpg"
      image_file = File.open("#{rich_menu_image_file_path}#{image_name}")
      response = client.create_rich_menu_image(rich_menu_id, image_file)
      p response.body
      client.set_default_rich_menu(rich_menu_id)
    end
  end

  # task :creates_menu_after_reservation => :environment do
  #   Constants::LINE_TYPE.keys.map do |line_type|
  #     client = Messenger::LineWrapper.new(line_type)

  #     if Rails.env.development?
  #       url = ENV['NGROK_URL']
  #     elsif Rails.env.production?
  #       url = "https://tabi-two.com"
  #     else
  #       nil
  #     end

  #     rich_menu_image_file_path = 'app/assets/rich_menus/'.freeze

  #     rich_menu={
  #       "size": {
  #         "width": 2500,
  #         "height": 1686
  #       },
  #       "selected": true,
  #       "name": "richmenu_after_reservation",
  #       "chatBarText": "TabiTabiメニュー",
  #       "areas": [
  #         {
  #           "bounds": {
  #             "x": 0,
  #             "y": 843,
  #             "width": 2500,
  #             "height": 843
  #           },
  #           "action": {
  #             "type": "uri",
  #             "uri": url ? LineUtil.add_line_param(url, line_type) : nil
  #           }
  #         },
  #         {
  #           "bounds": {
  #             "x": 0,
  #             "y": 0,
  #             "width": 2500,
  #             "height": 843
  #           },
  #           "action": {
  #             "type": "postback",
  #             "displayText": "旅行相談手伝って！",
  #             "data": "action=question_form&detail=after_reservation"
  #           }
  #         }
  #       ]
  #     }
  #     response = client.create_rich_menu(rich_menu)
  #     hash = JSON.parse(response.body)
  #     rich_menu_id = hash['richMenuId']
  #     unless rich_menu_id
  #       p hash
  #       next
  #     end
  #     rich_menu_name = "richmenu_after_reservation"
  #     if old_rich_menu = LineRichmenu.find_by(line_type: line_type, name: rich_menu_name)
  #       old_rich_menu_id = old_rich_menu.rich_menu_id
  #       response = client.delete_rich_menu(old_rich_menu_id)
  #       p response.body
  #       old_rich_menu.update!(
  #         rich_menu_id: rich_menu_id
  #       )
  #     else
  #       LineRichmenu.create!(
  #         line_type: line_type,
  #         rich_menu_id: rich_menu_id,
  #         name: rich_menu_name
  #       )
  #     end
  #     image_name = "rich_menu_image_after_reservaiton.jpg"
  #     image_file = File.open("#{rich_menu_image_file_path}#{image_name}")
  #     response = client.create_rich_menu_image(rich_menu_id, image_file)
  #     p response.body
  #   end
  # end

  # task :links_user_to_richmenu, ['chat_unit_id'] => :environment do |_task, args|
  #   chat_unit_id = args[:chat_unit_id]

  #   rich_menu_types = ["richmenu_after_reservation"].freeze

  #   hash = {}
  #   rich_menu_types.each do |rich_menu_name|
  #     hash[rich_menu_name] = {}
  #     LineRichmenu.where(name: rich_menu_name).map do |line_richmenu|
  #       hash[rich_menu_name][line_richmenu.line_type] = line_richmenu
  #     end
  #   end
  #   chat_units = chat_unit_id ? ChatUnit.where(id: chat_unit_id) : ChatUnit
  #   chat_units.with_flight_reservation.with_dynamic_package_reservation.with_hotel_reservation.find_each(batch_size: 100) do |chat_unit|
  #     next unless chat_unit.line?
  #     next if chat_unit.blocked

  #     line_richmenu_hash = hash[chat_unit.rich_menu_name]
  #     next unless line_richmenu_hash

  #     line_richmenu = line_richmenu_hash[chat_unit.line_type.to_s]
  #     next unless line_richmenu

  #     chat_unit.messenger_wrapper.link_user_to_menu(chat_unit, line_richmenu.rich_menu_id)
  #   end
  # end
end
