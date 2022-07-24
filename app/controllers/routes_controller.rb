class RoutesController < ApplicationController
  def new; end

  def index
    require 'uri'
    require 'net/http'
    require 'openssl'
    # 出発地の住所を緯度経度で取得
    start_point = params[:start_point]
    if start_point == ""
      flash.now[:danger] = '出発地が空欄になっています'
      render :new
      return
    end

    start_encoded = URI.encode_www_form({word: start_point})
    url = URI("https://navitime-geocoding.p.rapidapi.com/address?coord_unit=degree&datum=wgs84&limit=10&#{start_encoded}&sort=code_asc&offset=0")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["NAVITIME_KEY"]
    request["X-RapidAPI-Host"] = 'navitime-geocoding.p.rapidapi.com'

    response = http.request(request)
    hash = JSON.parse(response.body)

    #入力された住所から情報を取得できなかった場合
    if hash["count"]["total"] == 0
      flash.now[:danger] = '出発地の住所を正確に入力してください'
      render :new
      return
    end
    
    #入力された住所から情報を取得できた場合
    start_info = hash["items"][0]["coord"]
    start_hash = start_info.values_at('lat','lon')
    @start_lat_lon = start_hash.join(',')
    start_params = URI.encode_www_form({start: @start_lat_lon})
      

    # 到着地の住所を緯度経度で取得
    goal_point = params[:goal_point]
    if goal_point == ""
      flash.now[:danger] = '到着地が空欄になっています'
      render :new
      return
    end

    goal_encoded = URI.encode_www_form({word: goal_point})
    url = URI("https://navitime-geocoding.p.rapidapi.com/address?coord_unit=degree&datum=wgs84&limit=10&#{goal_encoded}&sort=code_asc&offset=0")

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["NAVITIME_KEY"]
    request["X-RapidAPI-Host"] = 'navitime-geocoding.p.rapidapi.com'

    response = http.request(request)
    hash = JSON.parse(response.body)
    #入力された住所から情報を取得できなかった場合
    if hash["count"]["total"] == 0
      flash.now[:danger] = '到着地の住所を正確に入力してください'
      render :new
      return
    end

    goal_info = hash["items"][0]["coord"]
    goal_hash = goal_info.values_at('lat','lon')
    @goal_lat_lon = goal_hash.join(',')
    goal_params = URI.encode_www_form({goal: @goal_lat_lon})

    # 希望到着時刻を受け取って、20分早い時間に変えて出発時刻を計算
    goal_time = params[:goal_time]
    if goal_time == ""
      flash.now[:danger] = '到着時刻が設定されていません'
      render :new
      return
    end

    fast_goal_time = Time.parse(goal_time).ago(20.minutes).strftime("%FT%R")
    goal_time_params = URI.encode_www_form({goal_time: goal_time})
    url = URI("https://navitime-route-totalnavi.p.rapidapi.com/route_transit?#{start_params}&#{goal_params}&#{goal_time_params}&datum=wgs84&term=1440&limit=5&coord_unit=degree")
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["NAVITIME_KEY"]
    request["X-RapidAPI-Host"] = 'navitime-route-totalnavi.p.rapidapi.com'
      
    response = http.request(request)
    hash = JSON.parse(response.body)
    start_time = hash["items"][0]["summary"]["move"]["from_time"]
    @start_time = Time.parse(start_time).strftime('%-m/%d %H:%M')
    
    #ルートの情報を取得
    @route_info = hash["items"][0]["sections"]
    
    #ルートの形状を取得
    url = URI("https://navitime-route-totalnavi.p.rapidapi.com/shape_transit?#{start_params}&#{goal_params}&#{goal_time_params}&options=transport_shape&format=geojson&term=1440&limit=5&datum=wgs84&coord_unit=degree")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["NAVITIME_KEY"]
    request["X-RapidAPI-Host"] = 'navitime-route-totalnavi.p.rapidapi.com'

    response = http.request(request)
    hash = JSON.parse(response.body)
    route = hash["features"]
    @route_shape = []
    route.each do |n|
      c = n["geometry"]["coordinates"]
      c.each do |m|
        @route_shape.push(m)
      end
    end
  end
end
