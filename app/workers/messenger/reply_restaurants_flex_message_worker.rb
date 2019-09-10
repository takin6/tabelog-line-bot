module Messenger
  class ReplyRestaurantsFlexMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(cache_id, page=1)
      Workers::ReplyRestaurantsFlexMessageBatch.new.execute(cache_id, page)
    end
  end
end
