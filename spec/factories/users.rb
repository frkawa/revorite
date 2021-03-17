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

  factory :alice, class: User do
    name {'Alice'}
    email {'alice@example.com'}
    password {'alicepass'}
    password_confirmation {'alicepass'}
  end

  factory :bob, class: User do
    name {'Bob'}
    email {'bob@example.com'}
    password {'bobpass'}
    password_confirmation {'bobpass'}
  end
end
