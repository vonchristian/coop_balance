class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :street,       class_name: "Addresses::Street", optional: true
  belongs_to :barangay,     class_name: "Addresses::Barangay", optional: true
  belongs_to :municipality, class_name: "Addresses::Municipality", optional: true
  belongs_to :province,     class_name: "Addresses::Province", optional: true

  def self.current
    where(current: true)
  end

  def self.recent
    order(created_at: :desc).first
  end

  def self.current_address
    current.recent
  end

  def details
    complete_address
  end
end
