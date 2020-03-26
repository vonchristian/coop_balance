FactoryBot.define do
  factory :member do
    first_name  { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }


    after(:build) do |member|
      member.avatar.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'default.png')), filename: 'default.png', content_type: 'image/png')
    end
  end
end
 