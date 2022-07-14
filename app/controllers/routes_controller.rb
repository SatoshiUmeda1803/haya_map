class RoutesController < ApplicationController
  def new
    require 'uri'
    require 'net/http'
    require 'openssl'
    
    # 希望到着時刻を受け取って、出発時刻を計算
    goal_time = params[:goal_time]
    params = URI.encode_www_form({goal_time: goal_time})
    url = URI("https://navitime-route-totalnavi.p.rapidapi.com/route_transit?start=35.665251%2C139.712092&goal=35.661971%2C139.703795&#{params}&datum=wgs84&term=1440&limit=5&coord_unit=degree")
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["NAVITIME_KEY"]
    request["X-RapidAPI-Host"] = 'navitime-route-totalnavi.p.rapidapi.com'
    
    response = http.request(request)
    hash = JSON.parse(response.body)
    start_time = hash["items"][0]["summary"]["move"]["from_time"]
    @start_time = Time.parse(start_time).strftime('%-m/%d %H:%M')
   
  end

  def create
   
  end
end
