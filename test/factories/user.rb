# Define factories for generating users
FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'test.user@example.com'
    password 'foobar'
    password_confirmation 'foobar'
    is_guest false
  end

  factory :guest, class: User do
    name User.random_name
    is_guest true
  end
end
