require 'rails_helper'

module ShareCapitals
  describe CapitalBuildUpPolicy do
    subject { ShareCapitals::CapitalBuildUpPolicy.new(user, record) }
    let(:record) { create(:saving) }
    context 'manager' do
      let(:user) { create(:user, role: 'general_manager') }

      it { is_expected.to_not permit_action(:new)}
      it { is_expected.to_not permit_action(:create)}
    end

    context 'loan_officer' do
      let(:user) { create(:user, role: 'loan_officer') }

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
