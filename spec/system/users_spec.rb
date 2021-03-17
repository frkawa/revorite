require 'rails_helper'

RSpec.describe 'Users', type: :system, js: true do
  let(:user) { create(:user) }
  let(:alice) { create(:alice) }
  let(:bob) { create(:bob) }
  before do
    @alice_post = create(:post, user_id: alice.id, text: '私はAliceよ。よろしくね。')
    @bob_post = create(:post, user_id: bob.id, text: '俺はBobだ。よろしくな。')
    user.follow(alice)
    Like.create(user_id: alice.id, post_id: @bob_post.id)
  end

  scenario '新規登録：トップページにリダイレクトすることを確認' do  
    visit new_user_registration_path

    fill_in 'user[name]', with: '初心者太郎'
    fill_in 'user[email]', with: 'beginner-tarou@example.com'
    fill_in 'user[password]', with: 'pass00'
    fill_in 'user[password_confirmation]', with: 'pass00'
    find('.signup-header').click  # 適当なところをクリックして（確認用）パスワードからフォーカスを外し、登録ボタンを活性化するJSを発火させる
    click_button '登録する'

    expect(page).to have_current_path root_path
  end

  scenario '新規登録→トップページ（リダイレクト）→プロフィール変更→自己紹介記入とアイコン画像のアップロード→マイページ（リダイレクト）：自己紹介の変更が反映されたことを確認' do  
    visit new_user_registration_path

    fill_in 'user[name]', with: '初心者太郎'
    fill_in 'user[email]', with: 'beginner-tarou@example.com'
    fill_in 'user[password]', with: 'pass00'
    fill_in 'user[password_confirmation]', with: 'pass00'
    find('.signup-header').click  # 適当なところをクリックして（確認用）パスワードからフォーカスを外し、登録ボタンを活性化するJSを発火させる
    click_button '登録する'

    click_link 'プロフィールの変更'
    
    fill_in 'user[description]', with: '今日から始めました。旅行が好きです。よろしくお願いします！'
    attach_file 'user[image]', "#{Rails.root}/spec/fixtures/files/profile-icon.jpg", make_visible: true
    click_button '変更する'

    expect(page).to have_content 'マイページ'
    expect(page).to have_content '今日から始めました。旅行が好きです。よろしくお願いします！'
    expect(page).to have_selector "img[src$='profile-icon.jpg']"
  end

  scenario '新規登録→トップ→みんなの投稿→Aliceユーザページへ→フォロー→マイページ→フォロー一覧：フォローした相手が存在することを確認' do  
    visit new_user_registration_path

    fill_in 'user[name]', with: '初心者太郎'
    fill_in 'user[email]', with: 'beginner-tarou@example.com'
    fill_in 'user[password]', with: 'pass00'
    fill_in 'user[password_confirmation]', with: 'pass00'
    find('.signup-header').click  # 適当なところをクリックして（確認用）パスワードからフォーカスを外し、登録ボタンを活性化するJSを発火させる
    click_button '登録する'

    click_link 'みんなの投稿', match: :first
    
    click_link 'Alice'

    find('.button-follow').click  # Aliceのページのフォローボタンを押す
    click_link '初心者太郎'

    click_link 'フォロー'

    expect(page).to have_content 'Alice'
  end

  scenario 'ログイン→新規投稿画面→投稿（レビュー無し・画像無し）：投稿が存在することを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    find('.button-newpost').click

    fill_in 'post[text]', with: '私は昨日から始めました。よろしくお願いします！'
    click_button '投稿'

    expect(page).to have_content '私は昨日から始めました。よろしくお願いします！'
    expect(page).to have_current_path root_path
  end

  scenario 'ログイン→新規投稿画面→投稿（レビューあり・画像あり）：投稿、画像、レビューが存在することを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    find('.button-newpost').click

    find('.checkbox-parts').click
    find("img[title$='GREAT']").click
    fill_in 'post[review_attributes][title]', with: 'シン・エヴァゲリオン'
    fill_in 'post[review_attributes][price]', with: '1800'
    fill_in 'post[text]', with: '先日観に行ってきました。面白かった。'
    attach_file 'post[images][]', "#{Rails.root}/spec/fixtures/files/eiga-wo-mita.png", make_visible: true
    click_button '投稿'

    expect(page).to have_current_path root_path
    expect(page).to have_selector ".post-review-star[rate$='4.5']"
    expect(page).to have_content '先日観に行ってきました。面白かった。'
    expect(page).to have_selector "img[src$='eiga-wo-mita.png']"
  end

  scenario 'ログイン→タイムライン→Aliceの投稿にコメント：コメントが反映されることを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    find('i.far.fa-comment-dots').click
    fill_in 'comment[message]', with: 'Alice、はじめまして。'
    attach_file 'comment[images][]', "#{Rails.root}/spec/fixtures/files/greet.png", make_visible: true
    click_button 'コメント'

    expect(page).to have_current_path root_path
    find('i.far.fa-comment-dots').click
    expect(page).to have_content 'Alice、はじめまして。'
    expect(page).to have_selector "img[src$='greet.png']"
  end

  scenario 'ログイン→みんなの投稿→Aliceの投稿をお気に入り→マイページ→お気に入り一覧：お気に入りに追加されたことを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    click_link 'みんなの投稿'

    page.first('i.far.fa-star').click
    click_link 'テストくん', match: :first

    click_link 'お気に入り'

    expect(page).to have_content '私はAliceよ。よろしくね。'
  end

  scenario 'ログイン→人気の投稿→Bobの投稿をリポスト→マイページ：投稿一覧にリポストした投稿が存在することを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    click_link '人気の投稿'

    page.first('i.fas.fa-retweet').click
    page.accept_confirm
    click_link 'テストくん', match: :first

    expect(page).to have_content 'テストくん さんがリポスト'
    expect(page).to have_content '俺はBobだ。よろしくな。'
  end

  scenario 'ログイン→人気の投稿→Bobの投稿をリポスト→タイムライン：タイムラインにリポストした投稿が存在することを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    click_link '人気の投稿'

    page.first('i.fas.fa-retweet').click
    page.accept_confirm
    click_link 'タイムライン'

    expect(page).to have_content 'テストくん さんがリポスト'
    expect(page).to have_content '俺はBobだ。よろしくな。'
  end

  scenario 'ログイン→新規投稿画面→投稿（レビュー無し・画像無し）→投稿の削除：投稿が削除されたことを確認' do  
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    find('.button-newpost').click

    fill_in 'post[text]', with: '私は昨日から始めました。よろしくお願いします！'
    click_button '投稿'

    page.first('i.fas.fa-trash-alt').click
    page.accept_confirm

    expect(page).not_to have_content '私は昨日から始めました。よろしくお願いします！'
  end

  scenario '新規登録→トップ→プロフィール変更画面→アカウントの削除：アカウントが削除されたことを確認' do  
    visit new_user_registration_path

    fill_in 'user[name]', with: '初心者太郎'
    fill_in 'user[email]', with: 'beginner-tarou@example.com'
    fill_in 'user[password]', with: 'pass00'
    fill_in 'user[password_confirmation]', with: 'pass00'
    find('.signup-header').click  # 適当なところをクリックして（確認用）パスワードからフォーカスを外し、登録ボタンを活性化するJSを発火させる
    click_button '登録する'

    click_link 'プロフィールの変更'
    
    click_link '>> アカウントの削除'
    page.accept_confirm

    expect(page).to have_current_path new_user_session_path
    fill_in 'user[email]', with: 'beginner-tarou@example.com'
    fill_in 'user[password]', with: 'pass00'
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います'
  end
end