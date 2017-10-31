class Organization < ApplicationRecord
  has_many :organization_members
  has_many :member_members, through: :organization_members, source: :organization_membership, source_type: "Member"
  has_many :employee_members, through: :organization_members, source: :organization_membership, source_type: "User"

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
    member_members + employee_members
  end
  def members_with_loans
    member_members.with_loans
  end
end
