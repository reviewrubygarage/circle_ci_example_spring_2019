FactoryBot.define do
  factory :student_attendance do
    zone
    identifier { FFaker::Name.name }
    first_seen_at { DateTime.now }
    last_seen_at { DateTime.now + 42.minutes }
  end
end
