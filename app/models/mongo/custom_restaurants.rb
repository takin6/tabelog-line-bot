module Mongo
  class CustomRestaurants
    include Mongoid::Document
    include Mongoid::Timestamps

    field :cache_id
    field :mongo_restaurants_id
    field :meal_type
    field :max_page
    field :restaurants

    def self.create_document!(search_history, mongo_restaurants)
      restaurants = sort_with_search_history(search_history, mongo_restaurants.restaurants)
      document = [
        insert_one: {
          cache_id: search_history.cache_id,
          mongo_restaurants_id: mongo_restaurants.id.to_s,
          max_page: (restaurants.count / 8.0).ceil,
          meal_type: search_history.meal_type,
          restaurants: restaurants
        }
      ]

      return self.collection.bulk_write(document)
    end

    # display index for user
    def create_apparent_index(apparent_page)
      page = apparent_page - 1
      if page == 0
        from = 1
        to = apparent_page == self.max_page ? self.restaurants.length : 9
      else
        from = page * 9 + 1
        to = apparent_page == self.max_page ? self.restaurants.length : apparent_page * 9
      end

      return from, to
    end

    # for selecting mongo documents
    def create_mongo_index(apparent_page)
      page = apparent_page - 1
      if page == 0
        from = 0
        to = apparent_page == self.max_page ? self.restaurants.length-1 : 8
      else
        from = page * 9
        to = apparent_page == self.max_page ? self.restaurants.length-1 : apparent_page * 9 -1
      end

      return from, to
    end

    def next_page(current_page)
      return nil if current_page + 1 > self.max_page

      return current_page + 1
    end

    private

    def self.sort_with_search_history(search_history, restaurants)
      # TODO: situation, other_requestsでのソート
      result = sort_restaurants_by_budget(restaurants, search_history.meal_type, search_history.lower_budget, search_history.upper_budget)
      result = sort_restaurants_by_rating(result)
      meal_genre = search_history.meal_genre
      result = sort_restaurants_by_meal_genre(result, meal_genre) if meal_genre

      return result
    end

    def self.sort_restaurants_by_budget(restaurants, meal_type, requested_lower_budget, requested_upper_budget)
      # この冗長なコードどうにかしたい。。。
      # mongo::restaurantsに登録するときはwrapperのままにするのはどうだろう？？まあwrapperで色々と定義したい
      target_key = (meal_type+"_budget").to_sym
      available_restaurants = select_available_restaurants(restaurants, target_key)
      if requested_lower_budget != 0 && requested_upper_budget != 0
        return available_restaurants.select do |restaurant|
          lower_budget, upper_budget = restaurant[target_key]
          lower_budget <= requested_lower_budget && upper_budget <= requested_upper_budget
        end
      else
        if requested_upper_budget != 0
          return available_restaurants.select do |restaurant|
            lower_budget, upper_budget = restaurant[target_key].map(&:to_i)
            upper_budget <= requested_upper_budget
          end
        elsif requested_lower_budget != 0
          return available_restaurants.select do |restaurant|
            lower_budget, upper_budget = restaurant[target_key].map(&:to_i)
            lower_budget <= requested_lower_budget
          end
        else
          return available_restaurants
        end
      end
    end

    def self.select_available_restaurants(restaurants, target_key)
      # exclude restaurnats with no price range == not available
      return restaurants.select do |restaurant|
        lower_budget, upper_budget = restaurant[target_key]
        ![lower_budget, upper_budget].include?(nil)
      end
    end

    # ここもカスタマイズ？？
    def self.sort_restaurants_by_rating(restaurants)
      return restaurants.sort_by do |restaurant|
        restaurant[:rating]
      end.reverse
    end

    def self.sort_restaurants_by_meal_genre(restaurants, requested_meal_genre)
      return restaurants.select do |restaurant|
        restaurant[:genre].include?(requested_meal_genre)
      end
    end

  end
end