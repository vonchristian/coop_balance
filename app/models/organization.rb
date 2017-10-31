class Organization < ApplicationRecord
  has_many :organization_members
  has_many :member_members, through: :organization_members, source: :organization_membership, source_type: "Member"
  has_many :employee_members, through: :organization_members, source: :organization_membership, source_type: "User"

  def members
    member_members + employee_members
  end
end
