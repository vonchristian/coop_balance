FactoryBot.define do
  factory :street, class: "Addresses::Street" do
    barangay nil
    municipality nil
  end
end
