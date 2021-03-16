require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  it 'ログイン画面にアクセス' do  
    visit new_user_session_path
    expect(page).to have_content 'ログイン'
  end
end