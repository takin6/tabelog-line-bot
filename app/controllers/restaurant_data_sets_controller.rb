class RestaurantDataSetsController  < ApplicationController
  include SessionHelper
  before_action :get_mongo_custom_restaurants, :get_page, :embed_redirect_path_after_login, only: [:new]
  before_action :get_restaurant_data_set, only: %i[show]
  layout 'restaurants'

  def index
    unless current_user
      head :bad_request
    else
      @restaurant_data_sets = current_user.restaurant_data_sets do |restaurant_data_set|
        restaurant_data_set.decorate
      end
    end
  end

  def new
    if @mongo_custom_restaurants.present?
      @restaurants = @mongo_custom_restaurants.restaurants
      station_name = @mongo_custom_restaurants.station_name
      formatted_current_date = DatetimeUtil.get_formatted_date
      @default_modal_text = (formatted_current_date + "&nbsp;" + station_name).html_safe
  	  # @restaurants = Kaminari.paginate_array(@mongo_custom_restaurnats.restaurants).page(@page).per(10)
  	else
  	  head :bad_request
    end
  end

  def show
    unless current_user && @restaurant_data_set.user == current_user
      redirect_to root_path
    else
      @search_history = @restaurant_data_set.search_history
      @mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: @search_history.cache_id)
      @selected_restaurants = @mongo_custom_restaurants.restaurants.select do |restaurant|
        @restaurant_data_set.selected_restaurant_ids.include?(restaurant["id"])
      end
    end
  end

  def create
    unless current_chat_unit
      redirect_to root_path
    else
      render 'create'
    end
  end

  private

  def get_page
  	@page = params[:page] ? params[:page] : 1
  end

  def get_mongo_custom_restaurants
    @mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: params[:cache_id])
  end

  def get_restaurant_data_set
    @restaurant_data_set = RestaurantDataSet.find_by(cache_id: params[:cache_id])
  end
end
