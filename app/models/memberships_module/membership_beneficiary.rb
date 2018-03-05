module MembershipsModule
  class MembershipBeneficiary < ApplicationRecord
    belongs_to :membership
    belongs_to :beneficiary, polymorphic: true

    validate :beneficiary_is_not_the_same_cooperator?

    private
    def beneficiary_is_not_the_same_cooperator?
      errors[:base] << "The beneficiary is the same member" if beneficiary == membership.cooperator
    end
  end
end
