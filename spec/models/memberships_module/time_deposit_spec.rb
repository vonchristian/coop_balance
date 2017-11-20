require 'rails_helper'

module MembershipsModule
  describe TimeDeposit do
    context 'associations' do
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :time_deposit_product }
    	it { is_expected.to have_many :deposits }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :depositor_id }
      it { is_expected.to validate_presence_of :depositor_type }
      it { is_expected.to validate_presence_of :number_of_days }
      it { is_expected.to validate_numericality_of :number_of_days }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:time_deposit_product).with_prefix }
    end

    it '#balance' do
      time_deposit = create(:time_deposit)
      deposit = create(:entry_with_credit_and_debit, commercial_document: time_deposit)

      expect(time_deposit.balance).to eql(deposit.total)
    end
    it '.set_maturity_date' do
      time_deposit = create(:time_deposit, date_deposited: Date.today, number_of_days: 90)

      expect(time_deposit.maturity_date.to_date).to eql(Date.today + 90.days)
    end
    it '#set_account_number' do
      time_deposit = create(:time_deposit)

      expect(time_deposit.account_number).to eql(time_deposit.id)
    end
  end
end
