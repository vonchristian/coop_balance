require 'rails_helper'

module MembershipsModule
  describe MembershipBeneficiary do
    describe 'associations' do
      it { should belong_to :beneficiary }
      it { should belong_to :membership }
    end
  end
end
