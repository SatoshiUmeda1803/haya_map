# haya_map

■ サービス概要
出かける時に、ついついギリギリで到着してしまったり、遅刻してしまう人に
余裕を持って20分前に到着できるようにする
出発時間マネジメントアプリ

■メインのターゲットユーザー
遅刻癖がついている人
友人との待ち合わせ等で遅刻することが多々あり、遅刻してはいけない大事な用事(採用面接など)でもギリギリの到着になりがち

■ユーザーが抱える課題
出発しないといけない時間はわかっているものの、トイレが長引いたり、家の鍵が見つからなかったりで結局ギリギリの時間になってしまう。

■解決方法
実際に出ないといけない時間より20分早い時間を表示することで、時間の余裕を提供する。ただ、20分早く表示されるという事に慣れてしまうと結局ギリギリになる場合があるので、たまに通常の出発時間を表示することで、慣れを防止する。

■実装予定の機能
登録前のユーザー
  設定した到着予定時刻に合わせた、出発時刻を知ることができる。
  経路案内を見ることができる。(GoogleMapsAPI?)
  早めについた場合に一息つけるカフェ等を見つけることができる。(ホットペッパーAPI?)
登録済のユーザー
  よく使う出発地、目的地を登録することができる。
  出発時刻をどれだけ早くするか設定することができる。
  慣れ防止機能(たまに通常の時刻を表示する)を使用することができる。

■なぜこのサービスを作りたいのか？
私は何か予定があったりすると、早くからソワソワしてしまったり、かなり早く目的地についてしまったりするタイプの人間です。
ただ、友人と待ち合わせしたりする時に、私が10分前に到着しても、友人が30分遅れてきたりした時に、「何の為の10分前行動だったのか」「私のソワソワしたあの時間を返してほしい」という気持ちが湧き上がってくることが多々ありました。
そんな悲しみを無くすために、遅刻しがちな人にぜひ使ってもらいたいと思ったからです。

■スケジュール
　企画〜技術調査：6/20〆切
　README〜ER図作成： 6/27〆切
　メイン機能実装：6/28 - 7/28
　β版をRUNTEQ内リリース（MVP）：7/28〆切
　本番リリース：8/11〆切

◆画面偏移図リンク
 https://www.figma.com/file/nSrM67jnJfzBVVVOIMZC8P/haya_map?node-id=0%3A1