module Mongo
  class RestaurantWrapper
    attr_reader :restaurant

    def initialize(restaurant)
      @restaurant = restaurant
    end

    def to_restaurant_document
      redirect_url =  restaurant.search(".list-rst__rst-name-target.cpy-rst-name")[0].values.select { |element| UrlUtil.valid_url?(element) }[0]
      area_genre_text = restaurant.search(".cpy-area-genre").text.strip!
      # thumbnail_image, url, name, rating, 予算, genre
      restaurant_hash = {
        id: struct_restaurant_id(redirect_url),
        name: restaurant.search(".list-rst__rst-name-target.cpy-rst-name")[0].text,
        rating: restaurant.search(".c-rating__val.c-rating__val--strong.list-rst__rating-val").text.to_f,
        area_genre: area_genre_text,
        master_genres: struct_master_genres(area_genre_text),
        lunch_budget: restaurant.search(".cpy-lunch-budget-val").text.remove(",").remove("￥").split("～").map(&:to_i),
        dinner_budget: restaurant.search(".cpy-dinner-budget-val").text.remove(",").remove("￥").split("～").map(&:to_i),
        redirect_url: redirect_url,
        thumbnail_image_url: restaurant.search(".js-thumbnail-img")[0].values.select { |element| UrlUtil.valid_url?(element) }[0].sub(/150x150_square_/, ''),
      }

      return restaurant_hash
    end

    def struct_master_genres(area_genre_text)
      genres_arr = area_genre_text.split("/")[1].split("、").map(&:strip)
      result = []
      master_genres = MasterRestaurantGenre.all.map(&:to_h)

      genres_arr.each do |genre|
        master_genres.map do |master_genre|
          if master_genre[:child_genres].include?(genre)
            result.push(master_genre.dig(:parent_genre))
            master_genres.delete(master_genre)
          end
        end
      end

      return result
    end

    def struct_restaurant_id(redirect_url)
      redirect_url.remove("https://tabelog.com").strip.split("/").reject!(&:empty?).join("-")
    end
  end
end
