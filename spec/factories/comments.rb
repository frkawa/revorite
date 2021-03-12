FactoryBot.define do
  factory :comment do
    association :post
    user { post.user }
    message {"これはコメント本文です"}
  end
end
