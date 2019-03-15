require 'rails_helper'

module SavingsModule
  module BalanceAveragers
    describe Quarterly do
      it "#averaged_balance" do
        saving_product = create(:saving_product)
        saving = create(:saving, saving_product: saving_product)

        #january deposit
        deposit = build(:entry, commercial_document: saving, entry_date: Date.current.beginning_of_year)
        deposit.credit_amounts << create(:credit_amount, amount: 5000, commercial_document: saving, account: saving.saving_product_account)
        deposit.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: saving, account: employee.cash_on_hand_account)
        deposit.save
      end
    end
  end
end
