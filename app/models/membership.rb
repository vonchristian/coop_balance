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
end
