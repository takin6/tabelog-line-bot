module Api
  class LineController < ActionController::API
    def callback
      result = Api::Line::ReceiveUsecase.new.receive(request)

      if result.success
        head :ok
      else
        head :bad_request
      end
    end

  end
end
