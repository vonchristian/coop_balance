require 'rails_helper'

describe BalanceStatusChecker do
  it "set_balance_status" do
    cooperative = create(:cooperative)
    employee = create(:user, role: 'teller', cooperative: cooperative)
    cash_on_hand_account = create(:asset, name: "Cash on Hand")
    employee.cash_accounts << cash_on_hand_account
    saving_product = create(:saving_product, minimum_balance: 500)
    saving = create(:saving, saving_product: saving_product)

    described_class.new(account: saving, product: saving_product).set_balance_status
    expect(saving.has_minimum_balance).to eq false 


    deposit = build(:entry, commercial_document: saving)
    deposit.credit_amounts << build(:credit_amount, amount: 5000, commercial_document: saving, account: saving.saving_product_account)
    deposit.debit_amounts << build(:debit_amount, amount: 5_000, commercial_document: saving, account: cash_on_hand_account)
    deposit.save!

    described_class.new(account: saving, product: saving_product).set_balance_status

    expect(saving.has_minimum_balance).to eq true
  end
end
