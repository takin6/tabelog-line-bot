class SearchRestaurantsController < ApplicationController
  layout 'search_restaurant'

  def new
    @master_restaurant_genres = MasterRestaurantGenre.all
    @search_history = SearchHistory.last
  end
end
