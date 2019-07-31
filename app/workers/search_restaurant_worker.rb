class SearchRestaurantWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0, dead: false

  def perform(user_id)
    Workers::SearchRestaurantBatch.new.execute(user_id)
  end
end
