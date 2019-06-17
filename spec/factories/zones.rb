FactoryBot.define do
  factory :zone do
    school
    name { FFaker::Lorem.word }
  end
end
