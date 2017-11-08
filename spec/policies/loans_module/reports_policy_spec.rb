require 'rails_helper'

module LoansModule
  describe ReportsPolicy do
    subject { LoansModule::ReportsPolicy.new(user, record) }
    let(:record) { create(:loan) }
    context 'loan officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { is_expected.to permit_action(:index) }
    end
    context 'stock custodian' do
      let(:user) { create(:user, role: 'stock_custodian') }

      it { is_expected.to_not permit_action(:index) }
    end
  end
end
