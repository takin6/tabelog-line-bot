class SearchRestaurantsController < ApplicationController
  include SessionHelper
  before_action :embed_redirect_path_after_login
  layout 'search_restaurant'

  def new
    @master_restaurant_genres = MasterRestaurantGenre.all
    @search_history = SearchHistory.last
  end
end
