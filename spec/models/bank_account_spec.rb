require 'rails_helper'

describe BankAccount do
  describe 'associations' do
    it { should belong_to :office }
    it { should belong_to :cash_account }
    it { should belong_to :interest_revenue_account }
  end

  describe 'validations' do
    it { should validate_presence_of :bank_name }
    it { should validate_presence_of :bank_address }
    it { should validate_presence_of :account_number }
  end

  describe 'delegations' do
    it { should delegate_method(:entries).to(:cash_account) }
    it { should delegate_method(:balance).to(:cash_account) }
    it { should delegate_method(:credits_balance).to(:cash_account) }
    it { should delegate_method(:debits_balance).to(:cash_account) }
  end

  it '#name' do
    bank = build(:bank_account, bank_name: 'LBP')
    expect(bank.name).to eql 'LBP'
  end
end
