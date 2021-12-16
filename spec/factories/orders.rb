FactoryBot.define do
  factory :order do
    status {rand(Order.statuses.values.first..Order.statuses.values.last)}
    shipping_fee {rand(10000..30000)}
    total_of_money {rand(100000..9999999)}
    user {FactoryBot.create(:user)}
    address {FactoryBot.create(:address)}
  end
end
