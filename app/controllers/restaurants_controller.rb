class RestaurantsController  < ApplicationController
  before_action :get_mongo_custom_restaurnats
  layout 'restaurants'

  def index; end

  private

  def get_mongo_custom_restaurnats
    @mongo_custom_restaurnats = Mongo::CustomRestaurants.find_by(cache_id: params[:cache_id])
  end
end
