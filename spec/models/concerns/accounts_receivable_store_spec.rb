require 'rails_helper'

describe AccountsReceivableStore do
  it '.total_payments(borrower)' do
    credit_account = create(:asset, name: "Cash on Hand")
    debit_account = create(:asset, name: "Accounts Receivables Trade - Current (General Merchandise)")
    borrower = create(:member)
    entry = build(:entry_with_credit_and_debit, commercial_document: borrower)
    debit_amount = create(:debit_amount, amount: 500, account: debit_account)
    credit_amount = create(:debit_amount, amount: 500, account: credit_account, entry: entry )
    entry.save

    expect(AccountsReceivableStore.new.total_payments(borrower)).to eql(600)
    expect(entry.total).to eql(600)
  end
end
