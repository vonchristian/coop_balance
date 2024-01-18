require 'rails_helper'

module StoreFrontModule
  describe ProductPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:product) }

    context 'sales clerk' do
      let(:user) { create(:user, role: 'sales_clerk') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end

    context 'stock custodian' do
      let(:user) { create(:user, role: 'stock_custodian') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end

    context 'loan_officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
    end
  end
end
