require 'rails_helper'

module AccountingModule
  describe AccountPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:asset) }

    context 'accountant' do
      let(:user) { create(:user, role: 'accountant') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
      it { should permit_action(:edit) }
      it { should permit_action(:update) }
    end

    context 'sales clerk' do
      let(:user) { create(:user, role: 'sales_clerk') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
      it { should_not permit_action(:edit) }
      it { should_not permit_action(:update) }
    end

    context 'loans officer' do
      let(:user) { create(:user, role: 'sales_clerk') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
      it { should_not permit_action(:edit) }
      it { should_not permit_action(:update) }
    end
  end
end
