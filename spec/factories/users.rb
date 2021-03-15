FactoryBot.define do
  factory :user do
    name {'テストくん'}
    email {'test@example.com'}
    password {'pass01'}
    password_confirmation {'pass01'}
  end

  factory :another_user, class: User do
    name {'テストちゃん'}
    email {'test02@example.com'}
    password {'pass02'}
    password_confirmation {'pass02'}
  end
end
