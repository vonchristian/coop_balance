require 'rails_helper'

module SavingsModule
  module BalanceAveragers
    describe Annually do
      it "#averaged_balance" do
        saving_product                 = create(:saving_product)
        saving_product_interest_config = create(:saving_product_interest_config, interest_posting: 'annually', saving_product: saving_product)
        saving                         = create(:saving, saving_product: saving_product)
        cash                           = create(:asset)
        
        deposit_1 = build(:entry, entry_date: Date.current.beginning_of_year)
        deposit_1.debit_amounts.build(account: cash, amount: 1_000)
        deposit_1.credit_amounts.build(account: saving.liability_account, amount: 1_000)
        deposit_1.save!

        deposit_2 = build(:entry, entry_date: Date.current.beginning_of_year.next_month)
        deposit_2.debit_amounts.build(account: cash, amount: 1_000)
        deposit_2.credit_amounts.build(account: saving.liability_account, amount: 1_000)
        deposit_2.save!

        deposit_3 = build(:entry, entry_date: Date.current.beginning_of_year.next_month.next_month)
        deposit_3.debit_amounts.build(account: cash, amount: 1_000)
        deposit_3.credit_amounts.build(account: saving.liability_account, amount: 1_000)
        deposit_3.save!

        withdrawal = build(:entry, entry_date: Date.current.end_of_year)
        withdrawal.debit_amounts.build(account: saving.liability_account, amount: 1_000)
        withdrawal.credit_amounts.build(account: cash, amount: 1_000)
        withdrawal.save!

     

        daily_averaged_balance = described_class.new(saving: saving, date: Date.current.end_of_year).daily_averaged_balance
        
        expect(daily_averaged_balance.round(2)).to eql  2748.63
       

      end 
    end
  end
end
