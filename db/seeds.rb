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
