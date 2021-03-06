# Define factories for generating users
FactoryGirl.define do
  factory :user do
    name 'Test User'
    sequence(:email) { |n| "test.user#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'
    is_guest false
    initialize_with  { User.find_or_create_by(email: email) }
  end

  factory :guest, class: User do
    name { "guest_#{rand(1000000)}" }
    is_guest true

    to_create do |instance|
      instance.save(validate: false)
    end
  end
end
