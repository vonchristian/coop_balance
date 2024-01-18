module Addresses
  class Province < ApplicationRecord
    has_many :municipalities, class_name: 'Addresses::Municipality'
    has_many :barangays, through: :municipalities, class_name: 'Addresses::Barangay'
  end
end
