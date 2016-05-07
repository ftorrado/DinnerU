# Define factories for generating comments
FactoryGirl.define do
  factory :comment do
    user
    content 'ok!'
  end
end
