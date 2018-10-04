class Membership < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:search_term]
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
  enum status: [:pending, :approved, :cancelled]

  belongs_to :cooperator, polymorphic: true
  belongs_to :cooperative
  has_many :membership_beneficiaries, class_name: "MembershipsModule::MembershipBeneficiary"
  has_many :beneficiaries, through: :membership_beneficiaries

  validates :cooperator_id, :cooperator_type, presence: true
  # validates :account_number, presence: true, uniqueness: true
  validates :cooperative_id, presence: true, uniqueness: { scope: :cooperator_id }

  delegate :avatar, to: :cooperator
  delegate :name, to: :cooperator, prefix: true
  delegate :savings, :share_capitals, :account_receivable_store_balance, to: :cooperator
  def self.for(options={})
    where(cooperative: options[:cooperative])
  end
  def name
    cooperator_name
  end

end
