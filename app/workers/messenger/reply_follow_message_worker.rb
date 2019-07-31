module Messenger
  class ReplyFollowMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(user_id)
      Workers::ReplyFollowMessageBatch.new.execute(user_id)
    end
  end
end