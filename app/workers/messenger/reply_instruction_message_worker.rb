module Messenger
  class ReplyInstructionMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: 0, dead: false

    def perform(chat_unit_id, is_initial_message=false)
      Workers::ReplyInstructionMessageBatch.new.execute(chat_unit_id, is_initial_message)
    end
  end
end
