require 'rails_helper'

module MembershipsModule
  describe TimeDeposit do
    context 'associations' do
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :time_deposit_product }
    	it { is_expected.to have_many :deposits }
      it { is_expected.to have_many :fixed_terms }

    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :depositor_id }
      it { is_expected.to validate_presence_of :depositor_type }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:time_deposit_product).with_prefix }
    end


    it '#balance' do
      time_deposit = create(:time_deposit)
      deposit = create(:entry_with_credit_and_debit, commercial_document: time_deposit)

      expect(time_deposit.balance).to eql(deposit.total)
    end

    it '#set_account_number' do
      time_deposit = create(:time_deposit)

      expect(time_deposit.account_number).to eql(time_deposit.id)
    end
  end
end
