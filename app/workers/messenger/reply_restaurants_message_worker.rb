module Messenger
  class ReplyRestaurantsMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(restaurant_data_subset_id, page=1)
      Workers::ReplyRestaurantsMessageBatch.new.execute(restaurant_data_subset_id, page)
    end
  end
end
