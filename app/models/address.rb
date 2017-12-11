class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :street, class_name: "Addresses::Street"
  belongs_to :barangay, class_name: "Addresses::Barangay"
  belongs_to :municipality, class_name: "Addresses::Municipality"
  belongs_to :province, class_name: "Addresses::Province"
  def self.current_address
    order(created_at: :asc).where(current: true).last
  end
  def details
    "#{street.name}, #{barangay.name}, #{municipality.name}, #{province.name}"
  end
end
