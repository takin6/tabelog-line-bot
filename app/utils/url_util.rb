require 'uri'

class UrlUtil
  def self.valid_url?(string)
    url = URI.parse(string)
    !url.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
