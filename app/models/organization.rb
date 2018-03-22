class Organization < ApplicationRecord
  has_many :organization_members, class_name: "Organizations::OrganizationMember"
  has_many :member_memberships, through: :organization_members, source: :organization_membership, source_type: "Member"
  has_many :employee_memberships, through: :organization_members, source: :organization_membership, source_type: "User"
  has_many :loans, class_name: "LoansModule::Loan"
  has_many :savings, class_name: "MembershipsModule::Saving", as: :depositor
  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/default_organization_avatar.png",
  :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
  :url => "/system/:attachment/:id/:basename_:style.:extension"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def members
    member_memberships + employee_memberships
  end
end
