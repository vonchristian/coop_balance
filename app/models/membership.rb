class Membership < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:search_term]
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
  enum status: [:pending, :approved, :cancelled]
  BLACKLISTED_MEMBERSHIP_TYPE = ['organization', 'special_depositor']

  belongs_to :cooperator, polymorphic: true
  belongs_to :cooperative
  has_many :membership_beneficiaries, class_name: "MembershipsModule::MembershipBeneficiary"
  has_many :beneficiaries, through: :membership_beneficiaries

  validates :cooperator_id, :cooperator_type, presence: true
  validates :cooperative_id, presence: true, uniqueness: { scope: :cooperator_id }

  delegate :avatar, to: :cooperator
  delegate :name, to: :cooperator, prefix: true
  delegate :name, to: :cooperative, prefix: true
  delegate :savings, :share_capitals, :account_receivable_store_balance, to: :cooperator

  def self.for_cooperative(cooperative)
    where(cooperative: cooperative)
  end

  def self.whitelisted_membership_types
    membership_types.keys - BLACKLISTED_MEMBERSHIP_TYPE
  end

  def self.approved_at(args={})
    from_date = args[:from_date]
    to_date   = args[:to_date]
    date_range     = DateRange.new(from_date: from_date, to_date: to_date)
    approved.where('approval_date' => date_range.range)
  end
  def self.for_cooperative(args={})
    where(cooperative: args[:cooperative])
  end

  def self.approved_memberships(args={})
  end

  def name
    cooperator_name
  end

  def self.current
    order(created_at: :desc).first || "None"
  end

end
