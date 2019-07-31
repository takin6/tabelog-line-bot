# module Messenger
#   class ReplyErrorMessageWorker
#     include Sidekiq::Worker
#     sidekiq_options retry: 0, dead: false

#     def perform(user_id, message_id)
#       Workers::ReplyErrorMessageBatch.new.execute(user_id, message_id)
#     end
#   end
# end