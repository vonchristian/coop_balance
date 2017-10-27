require 'rails_helper'

module AccountingModule
  describe AccountPolicy do
    subject { AccountingModule::AccountPolicy.new(user, record) }
    let(:record) { create(:account) }

    context 'accountant' do
      let(:user) { create(:user, role: 'accountant') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end

    context 'sales clerk' do
      let(:user) { create(:user, role: 'sales_clerk') }

      it { is_expected.to_not permit_action(:new) }
      it { is_expected.to_not permit_action(:create) }
    end
  end
end
