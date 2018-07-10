class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :street,       class_name: "Addresses::Street", optional: true
  belongs_to :barangay,     class_name: "Addresses::Barangay"
  belongs_to :municipality, class_name: "Addresses::Municipality"
  belongs_to :province,     class_name: "Addresses::Province"
  validates :barangay_id, :municipality_id, :province_id, presence: true

  def self.current_address
    order(created_at: :desc).where(current: true).first || NullAddress.new
  end

  def details
    "#{street.try(:name)}, #{barangay.name}, #{municipality.name}, #{province.name}"
  end
end
