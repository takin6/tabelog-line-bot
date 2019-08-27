module Messenger
  class ReplyRestaurantsFlexMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(cache_id, page=1)
      Rails.logger.info "reached!!!"
      Workers::ReplyRestaurantsFlexMessageBatch.new.execute(cache_id, page)
    end
  end
end
