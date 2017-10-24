require 'rails_helper'

module MembershipsModule
  describe Saving do
    context "associations" do 
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :saving_product }
    	it { is_expected.to have_many :entries }
    end 
    context 'delegations' do 
    	it { is_expected.to delegate_method(:name).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:current_occupation).to(:depositor).with_prefix }
    	it { is_expected.to delegate_method(:interest_rate).to(:saving_product).with_prefix }
    end

    it '#balance' do
      saving = create(:saving)
      deposit = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'deposit') 
      withdrawal = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'withdrawal') 
      savings_interest = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'savings_interest') 
      
      expect(saving.balance).to eql(100)
    end

    it '#deposits' do 
    	saving = create(:saving)
      entry = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'deposit') 
 
      expect(saving.deposits).to eql(100)
    end 

    it '#withdrawals' do 
    	saving = create(:saving)
      entry = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'withdrawal') 
 
      expect(saving.withdrawals).to eql(100)
    end

    it '#interests_earned' do 
    	saving = create(:saving)
      entry = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'savings_interest') 
 
      expect(saving.interests_earned).to eql(100)
    end 

    context '#can_withdraw?' do 
    	it 'TRUE if balance is greater than 0' do 
    		saving = create(:saving)
        deposit = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'deposit') 
        withdrawal = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'withdrawal') 
        savings_interest = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'savings_interest') 
      
        expect(saving.balance).to eql(100)
        expect(saving.can_withdraw?).to be true
    	end 

    	it 'FALSE if balance is less than 0' do 
    		saving = create(:saving)
        deposit = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'deposit') 
        withdrawal = create(:entry_with_credit_and_debit, commercial_document: saving, entry_type: 'withdrawal') 
  
        expect(saving.balance).to eql(0)
        expect(saving.can_withdraw?).to be false
    	end 
    end 
  end 
end
