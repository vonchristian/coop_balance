# frozen_string_literal: true

require 'rails_helper'

describe SavingsAccounts::WithdrawInitiation do
  let!(:cash_account) { create(:asset) }
  let!(:savings_account) { create(:saving) }
  let!(:user) { create(:user) }
  let(:account_number) { SecureRandom.uuid }
  let(:params) do
    {
      savings_account: savings_account,
      employee: user,
      account_number: account_number,
      amount: 40,
      date: DateTime.current,
      or_number: 'test',
      description: 'test',
      cash_account_id: cash_account.id
    }
  end

  let(:run_service) { described_class.run(params) }
  let(:voucher) { run_service.result }

  context 'with valid params' do
    before do
      allow(savings_account).to receive(:balance).and_return(41)
    end

    it { expect(voucher.description).to eq params[:description] }
    it { expect(voucher.account_number).to eq(account_number   ) }
  end
end
