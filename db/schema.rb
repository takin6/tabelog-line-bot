# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_07_090024) do

  create_table "area_search_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.bigint "search_history_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_area_search_histories_on_area_id"
    t.index ["search_history_id"], name: "index_area_search_histories_on_search_history_id"
  end

  create_table "areas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "region_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_areas_on_region_id"
  end

  create_table "chat_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "chat_unit_id", null: false
    t.string "line_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_unit_id"], name: "index_chat_groups_on_chat_unit_id"
  end

  create_table "chat_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "chat_unit_id", null: false
    t.string "line_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_unit_id"], name: "index_chat_rooms_on_chat_unit_id"
  end

  create_table "chat_units", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "chat_type", null: false
    t.boolean "is_blocking", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_liffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "liff_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_search_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "search_history_id"
    t.string "location_type"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_type", "location_id"], name: "index_location_search_histories_on_location_type_and_location_id"
    t.index ["search_history_id"], name: "index_location_search_histories_on_search_history_id"
  end

  create_table "master_restaurant_genres", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "parent_genre", null: false
    t.string "child_genres", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "message_buttons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.json "actions", null: false
    t.string "text", null: false
    t.string "thumbnail_image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_buttons_on_message_id"
  end

  create_table "message_postbacks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.integer "mongo_custom_restaurants_id", null: false
    t.integer "page", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_postbacks_on_message_id"
  end

  create_table "message_restaurants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "mongo_custom_restaurants_id", null: false
    t.integer "page", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_restaurants_on_message_id"
  end

  create_table "message_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_texts_on_message_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "chat_unit_id", null: false
    t.integer "message_type", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_unit_id"], name: "index_messages_on_chat_unit_id"
  end

  create_table "regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restaurant_data_sets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "cache_id", null: false
    t.string "mongo_custom_restaurants_id", null: false
    t.json "selected_restaurant_ids", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_restaurant_data_sets_on_user_id"
  end

  create_table "search_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "meal_type", default: 1, null: false
    t.json "master_genres"
    t.string "custom_meal_genres"
    t.string "situation"
    t.string "other_requests"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cache_id", null: false
    t.integer "lower_budget_cents", default: 0, null: false
    t.string "lower_budget_currency", default: "JPY", null: false
    t.integer "upper_budget_cents", default: 0, null: false
    t.string "upper_budget_currency", default: "JPY", null: false
  end

  create_table "station_search_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "station_id", null: false
    t.bigint "search_history_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["search_history_id"], name: "index_station_search_histories_on_search_history_id"
    t.index ["station_id"], name: "index_station_search_histories_on_station_id"
  end

  create_table "stations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "area_id"
    t.string "name", null: false
    t.boolean "scraping_completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_stations_on_area_id"
  end

  create_table "user_communities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "community_type", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_type", "community_id"], name: "index_user_communities_on_community_type_and_community_id"
    t.index ["user_id"], name: "index_user_communities_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "chat_unit_id", null: false
    t.string "line_id", null: false
    t.string "name", null: false
    t.string "profile_picture_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["chat_unit_id"], name: "index_users_on_chat_unit_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "area_search_histories", "areas"
  add_foreign_key "area_search_histories", "search_histories"
  add_foreign_key "areas", "regions"
  add_foreign_key "chat_groups", "chat_units"
  add_foreign_key "chat_rooms", "chat_units"
  add_foreign_key "location_search_histories", "search_histories"
  add_foreign_key "message_buttons", "messages"
  add_foreign_key "message_postbacks", "messages"
  add_foreign_key "message_restaurants", "messages"
  add_foreign_key "message_texts", "messages"
  add_foreign_key "messages", "chat_units"
  add_foreign_key "restaurant_data_sets", "users"
  add_foreign_key "station_search_histories", "search_histories"
  add_foreign_key "station_search_histories", "stations"
  add_foreign_key "stations", "areas"
  add_foreign_key "user_communities", "users"
  add_foreign_key "users", "chat_units"
end
