module Barangays
	class BarangayMember < ApplicationRecord
		belongs_to :barangay, class_name: "Addresses::Barangay"
	  belongs_to :barangay_membership, polymorphic: true
	end
end
