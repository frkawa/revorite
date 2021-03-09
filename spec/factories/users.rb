FactoryBot.define do
  factory :user do
    name {'テストくん'}
    email {'test@example.com'}
    password {'pass01'}
    password_confirmation {'pass01'}
  end
end
