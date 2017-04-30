unless User.find_by(email: ENV['PERSONAL_EMAIL'])
  user = User.create!(
    email: ENV['PERSONAL_EMAIL'],
    password: 'password'
  )

  user.confirm
end

subreddit_names = [ 'GifRecipes' ]

subreddit_names.each do |name|
  Subreddit.find_or_create_by!(name: 'GifRecipes')
end
