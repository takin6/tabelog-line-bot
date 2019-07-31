module Messenger
  class ReplyInstructionMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(user_id)
      Workers::ReplyInstructionMessageBatch.new.execute(user_id)
    end
  end
end
