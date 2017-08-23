class Membership < ApplicationRecord
  belongs_to :memberable, polymorphic: true
  belongs_to :cooperative
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
end
