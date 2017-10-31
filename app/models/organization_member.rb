class OrganizationMember < ApplicationRecord
  belongs_to :member, polymorphic: true
  belongs_to :organization
  belongs_to :organization_membership, polymorphic: true
end
