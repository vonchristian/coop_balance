require 'rails_helper'

module Members
  describe ShareCapitalPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:time_deposit) }

    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end

    context 'teller' do
      let(:user) { create(:user, role: 'treasurer') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end
  end
end
