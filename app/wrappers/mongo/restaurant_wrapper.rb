module Mongo
  class RestaurantWrapper
    attr_reader :restaurant

    def initialize(restaurant)
      @restaurant = restaurant
    end

    def to_restaurant_document
      redirect_url =  restaurant.search(".list-rst__rst-name-target.cpy-rst-name")[0].values.select { |element| UrlUtil.valid_url?(element) }[0]
      
      # thumbnail_image, url, name, rating, 予算, genre
      restaurant_hash = {
        id: struct_restaurant_id(redirect_url),
        name: restaurant.search(".list-rst__rst-name-target.cpy-rst-name")[0].text,
        rating: restaurant.search(".c-rating__val.c-rating__val--strong.list-rst__rating-val").text.to_f,
        genre: restaurant.search(".cpy-area-genre").text,
        lunch_budget: restaurant.search(".cpy-lunch-budget-val").text.remove(",").remove("￥").split("～").map(&:to_i),
        dinner_budget: restaurant.search(".cpy-dinner-budget-val").text.remove(",").remove("￥").split("～").map(&:to_i),
        redirect_url: redirect_url,
        thumbnail_image_url: restaurant.search(".js-thumbnail-img")[0].values.select { |element| UrlUtil.valid_url?(element) }[0].sub(/150x150_square_/, ''),
      }

      Rails.logger.info "#{restaurant_hash}\n\n\n\n"
      return restaurant_hash
    end

    def struct_restaurant_id(redirect_url)
      redirect_url.remove("https://tabelog.com").strip.split("/").reject!(&:empty?).join("-")
    end
  end
end
