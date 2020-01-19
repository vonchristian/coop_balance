class OrganizationScope < ApplicationRecord
  belongs_to :organization
  belongs_to :account, polymorphic: true
end
