class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  def details
    "#{street}, #{barangay}, #{municipality}, #{province}"
  end
end
