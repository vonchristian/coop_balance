class Membership < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:search_term]
  belongs_to :cooperator, polymorphic: true
  belongs_to :cooperative
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
  enum status: [:pending, :approved, :cancelled]
  validates :cooperator_id, :cooperator_type, presence: true
  validates :account_number, presence: true, uniqueness: true
  before_validation :set_account_number
  delegate :avatar, to: :cooperator
  delegate :name, to: :cooperator, prefix: true
  delegate :savings, :share_capitals, :account_receivable_store_balance, to: :cooperator


  validates :cooperative_id, presence: true, uniqueness: { scope: :cooperator_id }
  validates :account_number, presence: true, uniqueness: true
  has_many :membership_beneficiaries, class_name: "MembershipsModule::MembershipBeneficiary"
  has_many :beneficiaries, through: :membership_beneficiaries

  before_save :set_search_term
  def name
    cooperator_name
  end
  def self.for(cooperative)
    where(cooperative: cooperative).last
  end
  def self.membership_for(options={})
    if options[:cooperative] && options[:cooperator]
      where(cooperative: options[:cooperative]).where(cooperator: options[:cooperator]).last
    end
  end
  def self.generate_account_number
    if self.last.present?
      order(created_at: :asc).last.account_number.succ
    else
      "#{Time.zone.now.year.to_s.last(2)}0000000001"
    end
  end
  private
  def set_account_number
    self.account_number ||= Membership.generate_account_number
  end

  def set_search_term
    self.search_term = self.cooperator_name
  end
end
