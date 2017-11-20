class Membership < ApplicationRecord
  belongs_to :memberable, polymorphic: true
  belongs_to :cooperative
  enum membership_type: [:regular_member, :associate_member, :organization, :special_depositor]
  validates :account_number, uniqueness: true, presence: true
  def self.generate_account_number
    if self.exists? && order(created_at: :asc).last.account_number.present?
      order(created_at: :asc).last.account_number.succ
    else
      "#{Time.zone.now.year.to_s.last(2)}000001"
    end
  end
end
