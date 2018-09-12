class Organization < ApplicationRecord
  has_one_attached :avatar
  has_many :organization_members, class_name: "Organizations::OrganizationMember"
  has_many :member_memberships, through: :organization_members, source: :organization_membership, source_type: "Member"
  has_many :employee_memberships, through: :organization_members, source: :organization_membership, source_type: "User"
  has_many :loans, class_name: "LoansModule::Loan", as: :borrower
  has_many :savings, class_name: "MembershipsModule::Saving", as: :depositor
  has_many :share_capitals, class_name: "MembershipsModule::ShareCapital", as: :subscriber
  has_many :time_deposits, class_name: "MembershipsModule::TimeDeposit", as: :depositor

  def members
    member_memberships + employee_memberships
  end
end
