FactoryBot.define do
  factory :comment do
    association :user
    association :post
    message {"これはコメント本文です"}
  end
end
