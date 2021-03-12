FactoryBot.define do
  factory :post do
    association :user
    text {"これは本文です"}
  end
end
