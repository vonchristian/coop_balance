require 'rails_helper'

describe MinimumBalanceChecker do
  it '#check_balance' do
    cooperative = create(:cooperative)
    saving_product = create(:saving_product, minimum_balance: 1_000)
    employee = create(:user, role: 'teller')
    employee_cash_account = create(:employee_cash_account, employee: employee)
    create(:saving)
    saving = create(:saving, saving_product: saving_product)

    # deposit less than required minimum_balance
    deposit = build(:entry, commercial_document: saving, cooperative: cooperative)
    deposit.credit_amounts << build(:credit_amount, amount: 500, commercial_document: saving, account: saving_product.account)
    deposit.debit_amounts << build(:debit_amount, amount: 500, commercial_document: saving, account: employee_cash_account.cash_account)
    deposit.save!

    described_class.new(account: saving, product: saving_product).check_balance!

    expect(saving.has_minimum_balance).to be false

    # deposit more than required minimum_balance
    deposit_2 = build(:entry, commercial_document: saving, cooperative: cooperative)
    deposit_2.credit_amounts << build(:credit_amount, amount: 600, commercial_document: saving, account: saving_product.account)
    deposit_2.debit_amounts << build(:debit_amount, amount: 600, commercial_document: saving, account: employee_cash_account.cash_account)
    deposit_2.save!

    described_class.new(account: saving, product: saving_product).check_balance!

    expect(saving.has_minimum_balance).to be true

    # withdraw below required minimum_balance
    withdrawal = build(:entry, commercial_document: saving, cooperative: cooperative)
    withdrawal.credit_amounts << build(:credit_amount, amount: 600, commercial_document: saving, account: employee_cash_account.cash_account)
    withdrawal.debit_amounts << build(:debit_amount, amount: 600, commercial_document: saving, account: saving_product.account)
    withdrawal.save!

    described_class.new(account: saving, product: saving_product).check_balance!

    expect(saving.has_minimum_balance).to be false
  end
end
