class Membership < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:search_term]
  belongs_to :memberable, polymorphic: true
  belongs_to :cooperative
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
  enum status: [:pending, :approved, :cancelled]
  validates :memberable_id, :memberable_type, presence: true
  validates :account_number, presence: true, uniqueness: true
  before_validation :set_account_number
  delegate :avatar, to: :memberable
  delegate :name, to: :memberable
  delegate :savings, :share_capitals, :account_receivable_store_balance, to: :memberable
  belongs_to :beneficiary, polymorphic: true

  validate :beneficiary_is_not_the_same_member?
  validates :cooperative_id, presence: true, uniqueness: { scope: :memberable_id }

  has_many :savings,                class_name: "MembershipsModule::Saving", foreign_key: 'membership_id'
  has_many :loans,                  class_name: "LoansModule::Loan"
  has_many :share_capitals,         class_name: "MembershipsModule::ShareCapital"
  has_many :time_deposits,          class_name: "MembershipsModule::TimeDeposit"
  has_many :program_subscriptions,  class_name: "MembershipsModule::ProgramSubscription"
  has_many :programs,               through: :program_subscriptions
  before_save :set_search_term
  def self.membership_for(options={})
    if options[:cooperative] && options[:memberable]
      membership = where(cooperative: options[:cooperative]).where(memberable: options[:memberable]).last
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
  def beneficiary_is_not_the_same_member?
    errors[:base] << "The beneficiary is the same member" if beneficiary == memberable
  end
  def set_search_term
    self.search_term = self.name
  end
end
