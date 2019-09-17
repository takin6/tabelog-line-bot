class SearchRestaurantsController < ApplicationController
  layout 'liff'

  def new
    @master_restaurant_genres = MasterRestaurantGenre.all
    @search_history = SearchHistory.last
  end
end
