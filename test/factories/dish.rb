# Define factories for generating meals
FactoryGirl.define do
  factory :dish do
    name 'Fish and Chips'
    info 'The classic British dish'
  end
  factory :dish1 do
    name 'Pizza'
    info 'It seems everyone loves pizza'
  end
end
