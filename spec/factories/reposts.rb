FactoryBot.define do
  factory :repost do
    association :post
    user { post.user }
  end
end
