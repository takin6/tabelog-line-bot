module Messenger
  class ReplyRestaurantsFlexMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(search_history_id, page=1)
      Workers::ReplyRestaurantsFlexMessageBatch.new.execute(search_history_id, page)
    end
  end
end
