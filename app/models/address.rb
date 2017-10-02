class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  def self.current 
    last.try(:details)
  end
  def details
    "#{street}, #{barangay}, #{municipality}, #{province}"
  end
end
