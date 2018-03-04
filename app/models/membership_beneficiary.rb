class MembershipBeneficiary < ApplicationRecord
  belongs_to :membership
  belongs_to :beneficiary, polymorphic: true
  validate :beneficiary_is_not_the_same_member?

  private
  def beneficiary_is_not_the_same_member?
    errors[:base] << "The beneficiary is the same member" if beneficiary == cooperator
  end
end
