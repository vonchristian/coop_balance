class OrganizationMember < ApplicationRecord
  belongs_to :organization
  belongs_to :organization_membership, polymorphic: true
end
