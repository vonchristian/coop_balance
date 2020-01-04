class MembershipCategory < ApplicationRecord
  belongs_to :cooperative

  validates :title, presence: true, uniqueness: { scope: :cooperative_id }
end
