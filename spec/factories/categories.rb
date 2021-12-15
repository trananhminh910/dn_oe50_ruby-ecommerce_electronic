FactoryBot.define do
  factory :category do
    name {Faker::Lorem.sentence(word_count: rand(1..3))}
    parent_id {Category.first&.id || ""}
  end
end
