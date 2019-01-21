require 'rails_helper'

describe BankAccount do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :office }
    it { is_expected.to belong_to :cash_account }
    it { is_expected.to belong_to :interest_revenue_account }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :bank_name }
    it { is_expected.to validate_presence_of :bank_address }
    it { is_expected.to validate_presence_of :account_number }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:entries).to(:cash_account) }
  end

  it "#name" do
    bank = build(:bank_account, bank_name: "LBP")
    expect(bank.name).to eql "LBP"
  end
end
