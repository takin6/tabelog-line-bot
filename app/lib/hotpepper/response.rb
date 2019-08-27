module Hotpepper
  class Response
    attr_reader :values
    def parse(response)
      @values = response
    end
  end
end