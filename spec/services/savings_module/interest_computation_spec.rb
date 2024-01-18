require 'rails_helper'

module SavingsModule
  describe InterestComputation do
    it '#compute_interest!' do
      saving_product = create(:saving_product)
      create(:saving_product_interest_config, interest_posting: 'annually', annual_rate: 0.03, minimum_balance: 500, saving_product: saving_product)
      saving  = create(:saving, saving_product: saving_product)
      cash    = create(:asset)

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

      interest = described_class.new(saving: saving, date: Date.current.end_of_year).compute_interest!

      expect(interest.to_f.round(2)).to eq 82.54
    end
  end
end