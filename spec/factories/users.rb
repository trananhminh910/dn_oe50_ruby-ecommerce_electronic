FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    name {"#{Faker::Name.first_name} #{Faker::Name.last_name}"}
    gender {User.genders.values.first}
    role {rand(User.roles.values.first..User.roles.values.last)}
    is_active {User.is_actives.values.first}
    password {"111111"}
    password_confirmation {"111111"}
  end
end
