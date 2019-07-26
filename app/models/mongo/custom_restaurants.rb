module Mongo
  class CustomRestaurants
    include Mongoid::Document
    include Mongoid::Timestamps

    field :search_history_id
    field :mongo_restaurants_id
    field :max_page
    field :restaurants

    def self.create_document!(search_history, mongo_restaurants)
      restaurants = sort_with_search_history(search_history, mongo_restaurants.restaurants)
      document = [
        insert_one: {
          search_history_id: search_history.id,
          mongo_restaurants_id: mongo_restaurants.id,
          max_page: (restaurants.count / 8.0).ceil,
          restaurants: sort_with_search_history(search_history, restaurants)
        }
      ]
      return self.collection.bulk_write(document)
    end

    def create_index(apparent_page)
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

    def next_page(current_page)
      return nil if current_page + 1 > self.max_page

      return current_page + 1
    end

    private

    def self.sort_with_search_history(search_history, restaurants)
      # TODO: situation, other_requestsでのソート
      result = sort_restaurants_by_rating(restaurants)
      result = sort_restaurants_by_budget(result, search_history.lower_budget, search_history.upper_budget)
      meal_genre = search_history.meal_genre
      result = sort_restaurants_by_meal_genre(result, meal_genre) if meal_genre

      return result
    end

    # ここもカスタマイズ？？
    def self.sort_restaurants_by_rating(restaurants)
      return restaurants.sort_by do |restaurant|
        restaurant[:rating]
      end.reverse
    end

    def self.sort_restaurants_by_budget(restaurants, requested_lower_budget, requested_upper_budget)
      # この冗長なコードどうにかしたい。。。
      # mongo::restaurantsに登録するときはwrapperのままにするのはどうだろう？？まあwrapperで色々と定義したい
      if requested_lower_budget != 0 && requested_upper_budget != 0
        return restaurants.select do |restaurant|
          lower_budget, upper_budget = restaurant[:budget]
          lower_budget.to_i <= requested_lower_budget && upper_budget.to_i <= requested_upper_budget
        end
      else
        if requested_upper_budget != 0
          return restaurants.select do |restaurant|
            lower_budget, upper_budget = restaurant[:budget]
            upper_budget.to_i <= requested_upper_budget
          end
        elsif requested_lower_budget != 0
          return restaurants.select do |restaurant|
            lower_budget, upper_budget = restaurant[:budget]
            lower_budget.to_i <= requested_lower_budget
          end
        else
          return restaurants
        end
      end
    end

    def self.sort_restaurants_by_meal_genre(restaurants, requested_meal_genre)
      return restaurants.select do |restaurant|
        restaurant[:genre].include?(requested_meal_genre)
      end
    end

  end
end