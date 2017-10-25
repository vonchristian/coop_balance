require 'rails_helper'

module SavingsAccounts
  describe AccountClosingPolicy do
    subject { SavingsAccounts::AccountClosingPolicy.new(user, record) }
    let(:record) { create(:entry_with_credit_and_debit) }
    context 'manager' do
      let(:user) { create(:user, role: 'manager') }

      it { is_expected.to_not permit_action(:new)}
      it { is_expected.to_not permit_action(:create)}
    end

    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { is_expected.to permit_action(:new)}
      it { is_expected.to permit_action(:create)}
    end
    context 'treasurer' do
      let(:user) { create(:user, role: 'treasurer') }

      it { is_expected.to permit_action(:new)}
      it { is_expected.to permit_action(:create)}
    end
  end
end
