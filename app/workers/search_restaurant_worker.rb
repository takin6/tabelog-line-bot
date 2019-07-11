class SearchRestaurantWorker
  include Sidekiq::Worker

  def perform(user_id)
    Workers::SearchRestaurantBatch.new.execute(user_id)
  end
end
