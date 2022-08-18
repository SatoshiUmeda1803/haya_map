# はやまっぷ

https://haya-map.com/

# サービス概要
<img width="1512" alt="スクリーンショット 2022-08-13 18 17 00" src="https://user-images.githubusercontent.com/99541405/184477407-a9afc874-a226-4408-95f4-c7be95a5cc2d.png">

思ったよりも早く着く、目的地までの経路と電車の乗り換え案内サービスです。  
自分は早めに行動しているのに、友人は遅刻してくる…という悲しみを二度と繰り返さないようにするために開発しました。

# 通常の経路案内アプリと違う点
・ユーザーから受け取った希望到着時刻よりも20分早い時刻でルートを計算します。ただ、早めの到着予定時刻をそのまま表示するとユーザーが油断して結局遅く出発する恐れがあるので、到着予定時刻にはユーザーが入力した通りの時刻を表示しています。  
・ユーザー登録を行えば、遅刻防止機能が利用できます。遅刻防止機能をONにすることで、ランダムに20分早く着いたり着かなかったり（入力した時刻通りに着く)します。それにより「どうせ早めに到着する」と考えてしまうことを予防します。

# 使い方
<img width="1508" alt="スクリーンショット 2022-08-13 18 35 33" src="https://user-images.githubusercontent.com/99541405/184478111-69cc85f2-cfc2-4459-9b2f-22e8aa560d4c.png">

出発地、目的地、希望到着時刻を入力することで、早めのルート案内が表示されます。

# 使用技術
・Ruby 2.7.6  
・Ruby on Rails 5.2.8  
・Google Maps Platform(Places API)  
・NAVITIME API(NAVITIME Maps/NAVITIME Route totalnavi)