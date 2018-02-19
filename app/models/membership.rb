class Membership < ApplicationRecord
  belongs_to :memberable, polymorphic: true
  belongs_to :cooperative
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
  enum status: [:pending, :approved, :cancelled]
  validates :memberable_id, :memberable_type, presence: true
  validates :account_number, presence: true, uniqueness: true
  before_validation :set_account_number
  delegate :name, to: :memberable
  delegate :savings, :share_capitals, :account_receivable_store_balance, to: :memberable
  belongs_to :beneficiary, polymorphic: true

  validate :beneficiary_is_not_the_same_member?
  validates :cooperative_id, uniqueness: { scope: :memberable_id }

  has_many :savings,                class_name: "MembershipsModule::Saving",
                                    as: :depositor
  has_many :loans,                  class_name: "LoansModule::Loan",
                                    as: :borrower
  has_many :share_capitals,         class_name: "MembershipsModule::ShareCapital",
                                    as: :subscriber
  has_many :time_deposits,          class_name: "MembershipsModule::TimeDeposit",
                                    as: :depositor
  has_many :program_subscriptions,  class_name: "MembershipsModule::ProgramSubscription",
                                    as: :subscriber
  has_many :programs,               through: :program_subscriptions

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
end
