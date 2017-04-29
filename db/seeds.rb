user = User.create!(
  email: ENV['PERSONAL_EMAIL'],
  password: 'password'
)

user.confirm
