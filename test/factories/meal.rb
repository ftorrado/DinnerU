# Define factories for generating meals
FactoryGirl.define do
  factory :meal do
    name 'DinnerU get together!'
    description 'This is the event description'
    location 'Dave Pub'
    date DateTime.new(2016, 5, 17, 20, 0, 0, '+1')
    is_visible true
    is_private false
  end

  factory :private_meal, class: Meal do
    name 'Sample private meal'
    is_visible false
    is_private true
  end
end
