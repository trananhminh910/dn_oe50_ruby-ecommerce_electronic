FactoryBot.define do
  factory :address do
    name {Faker::Name.name}
    address {Faker::Address.city}
    phone {Faker::PhoneNumber.cell_phone}
    user {FactoryBot.create(:user)}
  end
end
