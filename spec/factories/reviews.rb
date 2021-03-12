FactoryBot.define do
  factory :review do
    association :post
    rate {"3.5"}
    title {"シン・エヴァンゲリオン"}
  end
end
