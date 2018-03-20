FactoryBot.define do
  factory :mark_up_price, class: "StoreFrontModule::MarkUpPrice" do
    price "9.99"
    date Time.zone.now
    unit_of_measurement nil
  end
end

