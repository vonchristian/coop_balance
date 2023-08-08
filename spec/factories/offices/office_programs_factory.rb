FactoryBot.define do
  factory :office_program, class: Offices::OfficeProgram do
    association :program
    association :office
  end
end
