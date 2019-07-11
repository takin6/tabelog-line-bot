module Messenger
  class ReplyRestaurantsFlexMessageWorker
    include Sidekiq::Worker

    def perform(search_history_id, pager=1)
      Workers::ReplyRestaurantsFlexMessageBatch.new.execute(search_history_id, pager)
    end
  end
end
