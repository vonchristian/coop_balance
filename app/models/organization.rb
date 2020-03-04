class Organization < ApplicationRecord
  include PgSearch::Model
  include Addressing
  include Contactable

  pg_search_scope :text_search, against: [:name, :abbreviated_name]
  has_one_attached :avatar
  belongs_to :cooperative
  has_many :organization_members, class_name: "Organizations::OrganizationMember"
  has_many :member_memberships, through: :organization_members, source: :organization_membership, source_type: "Member"
  has_many :employee_memberships, through: :organization_members, source: :organization_membership, source_type: "User"
  has_many :loans, class_name: "LoansModule::Loan", as: :borrower
  has_many :savings, class_name: "MembershipsModule::Saving", as: :depositor
  has_many :share_capitals,        class_name: "MembershipsModule::ShareCapital", as: :subscriber
  has_many :time_deposits,         class_name: "MembershipsModule::TimeDeposit", as: :depositor
  has_many :member_savings,        class_name: "MembershipsModule::Saving"
  has_many :member_time_deposits,  class_name: "MembershipsModule::TimeDeposit"
  has_many :member_share_capitals, class_name: "MembershipsModule::ShareCapital"
  has_many :member_loans, class_name: "LoansModule::Loan"

  has_many :addresses, as: :addressable
  has_many :account_scopes, as: :scopeable
  before_save :set_default_image

  

  def self.current
    last
  end

  def member_entries
    ids = []
    ids << member_loans.ids
    ids << member_share_capitals.ids
    entries = AccountingModule::Amount.where(commercial_document_id: ids).pluck(:entry_id)
    AccountingModule::Entry.where(id: entries)
  end

  def signatory_name
    name
  end

  def members
    member_memberships + employee_memberships
  end

  def name_and_details #for select2 referencing
    if name.present?
      "#{name} (Organization/Office)"
    else
      "#{abbreviated_name} (Organization/Office)"
    end
  end

  private
  def set_default_image
    if avatar.attachment.blank?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_business_logo.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
  end
end
