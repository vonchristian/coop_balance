require 'rails_helper'

module LoansModule
  describe ReportsPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:loan) }

    context 'loan officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { should permit_action(:index) }
    end

    context 'stock custodian' do
      let(:user) { create(:user, role: 'stock_custodian') }

      it { should_not permit_action(:index) }
    end
  end
end
