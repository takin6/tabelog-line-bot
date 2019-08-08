module Messenger
  class ReplyFollowMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(chat_unit_id)
      Workers::ReplyFollowMessageBatch.new.execute(chat_unit_id)
    end
  end
end