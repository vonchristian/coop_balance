require 'rails_helper'

module AccountingModule
  module Entries
    describe CancellationPolicy do
      subject { AccountingModule::Entries::CancellationPolicy.new(user, record) }
      let(:record) { create(:origin_entry) }

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
end
