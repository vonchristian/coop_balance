FactoryBot.define do
  factory :deactivation do
    deactivatable  { nil }
    remarks        { "MyText" }
    deactivated_at { "2019-03-11 12:24:30" }
    active         { false }
  end
end
