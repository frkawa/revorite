# Revorite

## Revorite = Review + Favorite.

Revoriteは、「スキ」をレビューすることができるSNSアプリです。 <br>
ジャンルを問わず好きな物をおすすめし合うことで、まだ見ぬ誰かの「推し」に出会うことができます。

<img width="800" alt="コンセプト画像_1" src="https://user-images.githubusercontent.com/57317752/111473080-fd8d1a00-876d-11eb-91cc-6f56c8138cfb.png">
<img width="800" alt="コンセプト画像_2" src="https://user-images.githubusercontent.com/57317752/111473129-0e3d9000-876e-11eb-9500-361a583e65d7.png">
<img width="450" alt="コンセプト画像_3" src="https://user-images.githubusercontent.com/57317752/111473870-d256fa80-876e-11eb-8ef4-79c7ad1d7f15.png">

## URL
<a target="_blank" href="https://www.revorite.net/">https://www.revorite.net/</a>（別窓で開きます） <br>
<br>
ページ上部の「かんたんログイン」より、ゲスト用アカウントにワンクリックでログインが可能です。 <br>
ゲスト用アカウントはアカウント削除を除く全ての機能が使えます。

## 使用技術
- Ruby 2.7.1
- Ruby on Rails 5.2.4.5
- jQuery 1.12.4
- MySQL 8.0.20
- Nginx 1.18.0
- Unicron 5.8.0
- Rspec 3.10
- Docker 20.10.3
- Capistrano 3.16.0
- AWS
  - IAM
  - VPC
  - EC2（踏み台サーバ、Webサーバ）
  - RDS
  - S3
  - Route 53
  - Amazon SES
  - CloudWatch

## ER図
<img width="1000" alt="ER図" src="https://user-images.githubusercontent.com/57317752/111494153-95483380-8781-11eb-9bd1-e077075c744b.png">

## ネットワーク構成図（開発環境、AWS）
<img width="1000" alt="ネットワーク構成図（開発環境、AWS）" src="https://user-images.githubusercontent.com/57317752/111482637-6e84ff80-8777-11eb-8b7a-399960f253f2.png">

## 機能一覧
- 認証機能（```devise```）
  - ユーザ登録機能
  - （かんたん）ログイン機能
  - プロフィール変更機能（```Active Storage```）
  - パスワード再発行機能
- 投稿表示機能
  - タイムライン：フォローしているユーザの投稿を表示
  - みんなの投稿：全てのユーザの投稿を表示
  - 人気の投稿：お気に入りに多く登録されている投稿を表示
- ユーザ情報表示機能
  - 投稿一覧、お気に入り一覧、フォロー・フォロワー一覧
- 投稿機能
  - 複数画像投稿機能（```Active Storage```） 
  - レビュー機能（投稿時にレビュー有無を選択）
  - 星（★）による5段階の評価機能（```raty```）
- コメント機能
  - 複数画像投稿機能（```Active Storage```） 
- お気に入り機能（```Ajax```）
- リポスト機能（```Ajax```）　※フォロワーに向けて他人の投稿を共有する機能
- フォロー機能（```Ajax```）
- 無限スクロール機能（```jScroll```、```kaminari```、```MutationObserver```）
- モーダルウィンドウでの画像拡大機能（```Luminous```）
- 画像遅延読み込み機能（```lazyload```）

## テスト
Rspecを利用したテストを実施
- 単体テスト（Model spec）
  - 各モデルのバリデーション、アソシエーション、クラスメソッドについて正常系・異常系の両方を検証
- 機能テスト（Request spec）
  - 各ルーティングに対してのリクエストやページリダイレクト、データ作成の成否を検証
- 統合テスト（System spec）
  - 実際のサービス利用を想定したシナリオを組み、ブラウザ上で実際にフォームを入力したりリンクをクリックするなどして想定通りにアプリが動作するかを検証
