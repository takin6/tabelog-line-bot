class RestaurantDataSetsController  < ApplicationController
  include SessionHelper
  before_action :get_mongo_custom_restaurants, :get_page, :embed_redirect_path_after_login, only: [:index]
  layout 'restaurants'

  def index
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
    unless current_chat_unit
      redirect_to root_path
    else
      render 'complete'
    end
  end

  private

  def get_page
  	@page = params[:page] ? params[:page] : 1
  end

  def get_mongo_custom_restaurants
    @mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: params[:cache_id])
  end
end
