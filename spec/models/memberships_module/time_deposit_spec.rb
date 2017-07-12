require 'rails_helper'

module MembershipsModule
  describe TimeDeposit do
    context 'associations' do 
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :time_deposit_product }
    	it { is_expected.to have_many :deposits }
    end 

    it '#balance' do
      time_deposit = create(:time_deposit)
      deposit = create(:entry_with_credit_and_debit, commercial_document: time_deposit)

      puts time_deposit.balance 
    end
  end 
end
