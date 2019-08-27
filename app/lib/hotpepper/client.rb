module Hotpepper
  class Client
    def initialize(
      ip = nil,
      user_agent = nil,
      test_header = nil
    )
      ip ||= "133.203.134.224"
      user_agent ||= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36"
      @request = Request.new(ip, user_agent, test_header)
    end

    def get_middle_areas(args={})
      @request.send_request("/middle_area/v1/", "get", args)
    end

    def search_restaurants(args)
      @request.send_request("/gourmet/v1/", "post", args)
    end
  end
end
