# Define factories for generating comments
FactoryGirl.define do
  factory :comment do
    user
    text 'ok!'
  end
end
