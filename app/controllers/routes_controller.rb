class RoutesController < ApplicationController
  def new; end

  def show
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
    url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{start_encoded}&inputtype=textquery&language=ja&region=ja&ipbias&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=#{ENV["GOOGLE_KEY"]}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    hash = JSON.parse(response.body)
 
    #入力された住所から情報を取得できた場合
    start_info = hash["candidates"][0]["geometry"]["location"]
    start_hash = start_info.values_at('lat','lng')
    @start_lat_lon = start_hash.join(',')
    start_params = URI.encode_www_form({start: @start_lat_lon})
    @start_name = hash["candidates"][0]["name"]
      
    # 到着地の住所を緯度経度で取得
    goal_point = params[:goal_point]
    if goal_point == ""
      flash.now[:danger] = '到着地が空欄になっています'
      render :new
      return
    end

    goal_encoded = URI.encode_www_form({word: goal_point})
    url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{goal_encoded}&inputtype=textquery&language=ja&region=ja&ipbias&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=#{ENV["GOOGLE_KEY"]}")

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    hash = JSON.parse(response.body)

    goal_info = hash["candidates"][0]["geometry"]["location"]
    goal_hash = goal_info.values_at('lat','lng')
    @goal_lat_lon = goal_hash.join(',')
    goal_params = URI.encode_www_form({goal: @goal_lat_lon})
    @goal_name = hash["candidates"][0]["name"]

    # 希望到着時刻を受け取る
    goal_time = params[:goal_time]
    
    if goal_time == ""
      flash.now[:danger] = '到着時刻が設定されていません'
      render :new
      return
    end

    @goal_time = Time.parse(goal_time)
    # ログイン状態か確認
    if logged_in?
      # 遅刻防止機能がオンになっているか確認して、オンならば10%の確率で入力された到着時刻通りでルート検索をする。
      if current_user.time_setting.randomized == true
        random = Random.rand(9)
        if random == 1
          fast_goal_time = @goal_time.strftime("%FT%R")
        else
          fast_goal_time = @goal_time.ago(current_user.time_setting.costom_time.minutes).strftime("%FT%R") 
        end
      else
        fast_goal_time = @goal_time.ago(current_user.time_setting.costom_time.minutes).strftime("%FT%R")
      end
    else
      fast_goal_time = @goal_time.ago(20.minutes).strftime("%FT%R")
    end
    
    goal_time_params = URI.encode_www_form({goal_time: fast_goal_time})
    url = URI("https://navitime-route-totalnavi.p.rapidapi.com/route_transit?#{start_params}&#{goal_params}&#{goal_time_params}&datum=wgs84&term=1440&limit=5&coord_unit=degree")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["NAVITIME_KEY"]
    request["X-RapidAPI-Host"] = 'navitime-route-totalnavi.p.rapidapi.com'
      
    response = http.request(request)
    hash = JSON.parse(response.body)
    if hash.empty? then
      flash.now[:danger] = 'ルートが見つけられませんでした。住所や建物名を変えてみてください。'
      render :new
      return
    end
    start_time = hash["items"][0]["summary"]["move"]["from_time"]
    @start_time = Time.parse(start_time).strftime('%H:%M')
    
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
