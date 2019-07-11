class ServiceResult
  attr_reader :success, :error
  def initialize(success, exception="")
    @success = success
    @error = exception.to_s
  end
end
