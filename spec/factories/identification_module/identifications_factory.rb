FactoryBot.define do
  factory :identification, class: "IdentificationsModule::Identification" do
    identiable { nil }
    number { "MyString" }
  end
end
