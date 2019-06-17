FactoryBot.define do
  factory :school do
    name { FFaker::Lorem.word }
    url_address { FFaker::Internet.http_url }
    username { FFaker::Name.first_name }
    password { FFaker::Lorem.word }
  end
end
