FactoryBot.define do
  factory :product do
    name {Faker::Commerce.product_name}
    price {rand(1000000..9999999)}
    discount {rand(0..100)}
    residual {rand(100..200)}
    description {Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4)}
    category {FactoryBot.create(:category)}
  end
end
