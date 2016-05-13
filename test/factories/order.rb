# Define factories for generating meals
FactoryGirl.define do
  factory :order do
    user
    description 'Order description'
  end
end
