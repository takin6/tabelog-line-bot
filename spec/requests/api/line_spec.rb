require 'rails_helper'

RSpec.describe "Api::LineController", type: :request do
  describe "POST api/line/callback_liff" do
    before :all do
      @chat_unit = create(:chat_unit, chat_type: :user)
      @user = create(:user, chat_unit: @chat_unit)

      @station = create(:station, name: "渋谷")
    end

    before :each do
      file = File.read(Rails.root.join("spec", "fixtures", "restaurants_shibuya.json"))
      create(:mongo_restaurants, station_id: @station.id, max_page: (JSON.parse(file).count / 8.0).ceil, restaurants: JSON.parse(file))

      post api_validate_chat_unit_path, params: {
        entity: {
          user: { line_id: @user.line_id, name: @user.name, profile_picture_url: @user.profile_picture_url }
        }
      }
    end

    let(:params) do
      {
        line_liff: {
          location: @station.name,
          meal_type: "dinner",
          genre: {
            custom_input: custom_input_param,
            master_genres: master_genres_param
          },
          budget: {lower: 0, upper: 0}
        }
      }
    end

    let(:custom_input_param) { "" }
    let(:master_genres_param) { nil }

    let(:send_request) { post api_line_callback_liff_path, params: params }

    context "returns http success" do
      context "only custom genres" do
        let(:custom_input_param) { "ハンバーグ" }

        it do
          expect do
            send_request
          end.to change(
            SearchHistory, :count
          ).by(1).and change(
            StationSearchHistory, :count
          ).by(1).and change(
            Mongo::CustomRestaurants, :count
          ).by(1)

          expect(Mongo::CustomRestaurants.last.restaurants.count).to eq 6
          expect(response).to have_http_status(200)
        end
      end

      context "custom genres + master_genres" do
        let(:custom_input_param) { "ハンバーグ" }
        let(:master_genres_param) { ["イタリアン"] }

        it do
          expect do
            send_request
          end.to change(
            SearchHistory, :count
          ).by(1).and change(
            StationSearchHistory, :count
          ).by(1).and change(
            Mongo::CustomRestaurants, :count
          ).by(1)

          expect(Mongo::CustomRestaurants.last.restaurants.count).to eq 1
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end