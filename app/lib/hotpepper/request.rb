module Hotpepper
  class Request
    HOTPEPPER_URL = "http://webservice.recruit.co.jp/hotpepper/".freeze

    include HTTParty
    format :json
    base_uri HOTPEPPER_URL

    def initialize(ip, user_agent, test_header)
      @ip = ip
      @user_agent = user_agent
      @test_header = test_header
    end

    def send_request(url, method, options = nil)
      response = self.send(method, url, options)
      parsed_response(response)
    end

    private

    def get(url, options)
      self.class.get(complete_url(url, options))
    end

    def complete_url(url, options)
      result = url + "?key=#{ENV["HOTPEPPER_API_KEY"]}&format=json"

      if options.present?
        options.each do |key, value|
          # parmas[key.to_sym] = value
          result += "&#{key}=#{value}"
        end
      end

      return result
    end

    def parsed_response(response)
      result = Hotpepper::Response.new
      result.parse(response.parsed_response)

      result
    end
  end
end