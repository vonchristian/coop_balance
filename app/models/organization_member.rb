class OrganizationMember < ApplicationRecord
  belongs_to :member
  belongs_to :organization
end
