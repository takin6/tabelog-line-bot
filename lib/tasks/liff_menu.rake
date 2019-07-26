require 'net/https'

namespace :line_liff do
  desc "get line liff"
  task :get_liff_list => :environment do
    uri = URI.parse("https://api.line.me/liff/v1/apps")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"

    response = http.start do |h|
      h.request(req)
    end
    p response.body
  end

  desc "create line liff"
  task :create_liff => :environment do
    uri = URI.parse("https://api.line.me/liff/v1/apps")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"
    req.body = '{
      "view": {
        "type": "full",
        "url": "https://68b29b71.ngrok.io/search_restaurants/new"
      }
    }'

    response = http.start do |h|
      h.request(req)
    end
    p response.body

    hash = JSON.parse(response.body)
    p hash
    liff_id = hash['liffId']
    liff_name = "search_restaurants"
    if old_liff = LineLiff.find_by(name: liff_name)
      old_liff_id = old_liff.liff_id

      uri = URI.parse("https://api.line.me/liff/v1/apps")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Delete.new("#{uri.request_uri}/#{old_liff_id}")
      req['Content-Type'] = 'application/json'
      req['Authorization'] = "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"

      response = http.start do |h|
        h.request(req)
      end
      p response.body

      old_liff.update(
        liff_id: liff_id
      )
    else
      LineLiff.create(
        liff_id: liff_id,
        name: liff_name
      )
    end
  end
end
