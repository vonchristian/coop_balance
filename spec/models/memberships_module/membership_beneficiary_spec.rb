require 'rails_helper'

module MembershipsModule
  describe MembershipBeneficiary do
    
    describe 'associations' do
      it { is_expected.to belong_to :beneficiary }
      it { is_expected.to belong_to :membership }
    end
  end
end
