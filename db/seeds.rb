User.create!(
  email: "trananhminh910@gmail.com",
  name: "Tran Anh Minh",
  gender: true,
  avatar: "1.png",
  role: 1,
  password: "111111",
  password_confirmation: "111111",
  is_active: true
)
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  gender = true
  password = "password"
  User.create!(
    name: name,
    email: email,
    gender: gender,
    avatar: "1.png",
    role: 0,
    password: password,
    password_confirmation: password,
    is_active: true,
  )
end

5.times do |n|
  name = %w[laptop PC tablet mobile headphone].sample
  parent_id = 1
  Category.create!(
    name: name,
    parent_id: parent_id
  )
end

30.times do |n|
  name = User.find(rand(1..20)).name
  address = Faker::Address.city
  phone = Faker::PhoneNumber.cell_phone
  user_id = rand(1..20)
  Address.create!(
    name: name,
    address: address,
    phone: phone,
    user_id: user_id
  )
end

30.times do |n|
  name = Faker::Commerce.product_name
  price = 200000
  image = "1.png"
  discount = 20
  residual = 100
  description = Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4)
  category_id = 1
  Product.create!(
    name: name,
    price: price,
    image: image,
    discount: discount,
    residual: residual,
    description: description,
    category_id: category_id
  )
end

30.times do |n|
  status = rand(0..3)
  shipping_fee = 20000
  total_of_money = 222222
  user_id = rand(1..20)
  address_id = rand(1..20)
  Order.create!(
    status: status,
    shipping_fee: shipping_fee,
    total_of_money: total_of_money,
    user_id: user_id,
    address_id: address_id
  )
end

30.times do |n|
  quantity = %w[0 1 2 3]
  autual_price = 200000
  order_id = rand(1..20)
  product_id = rand(1..20)
  OrderDetail.create!(
    quantity: quantity,
    autual_price: autual_price,
    order_id: order_id,
    product_id: product_id
  )
end
