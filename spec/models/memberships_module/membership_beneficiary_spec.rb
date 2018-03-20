require 'rails_helper'

module MembershipsModule
  describe MembershipBeneficiary do
    describe 'associations' do
      it { is_expected.to belong_to :beneficiary }
      it { is_expected.to belong_to :membership }
    end
    it "#beneficiary_is_not_the_same_cooperator?" do
      member = create(:member)
      membership = create(:membership, cooperator: member)
      beneficiary = create(:member)
      beneficiary_membership = create(:membership_beneficiary, beneficiary: beneficiary, membership: membership)
      invalid_beneficiary_membership = build(:membership_beneficiary, beneficiary: member, membership: membership)
      expect(beneficiary).to be_valid
      expect(invalid_beneficiary_membership).to_not be_valid
      expect(invalid_beneficiary_membership.errors['base']).to eq(["The beneficiary is the same member"])

    end
  end
end
