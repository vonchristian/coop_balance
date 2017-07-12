FactoryGirl.define do
  factory :program, class: "CoopServicesModule::Program" do
    name  { Faker::Company.name}
    contribution "9.99"
  end
end
