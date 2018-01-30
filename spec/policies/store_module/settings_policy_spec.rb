require 'rails_helper'

module StoreFrontModule
  describe SettingsPolicy do
    subject { StoreFrontModule::SettingsPolicy.new(user, record) }
    let(:record) { create(:product) }
    context 'sales clerk' do
      let(:user) { create(:user, role: 'sales_clerk') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end
    context 'stock custodian' do
      let(:user) { create(:user, role: 'stock_custodian') }

      it { is_expected.to_not permit_action(:new) }
      it { is_expected.to_not permit_action(:create) }
    end
    context 'loan_officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { is_expected.to_not permit_action(:new) }
      it { is_expected.to_not permit_action(:create) }
    end
  end
end
