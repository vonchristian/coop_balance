require 'rails_helper'

module LoansModule
  describe LoanProtectionFund do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :loan }
      it { is_expected.to belong_to :loan_protection_rate }
    end
  end
end
