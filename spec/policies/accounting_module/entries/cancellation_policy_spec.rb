require 'rails_helper'

module AccountingModule
  module Entries
    describe CancellationPolicy do
      subject { described_class.new(user, record) }
      let(:record) { create(:origin_entry) }

      context 'accountant' do
        let(:user) { create(:user, role: 'accountant') }

        it { should permit_action(:new) }
        it { should permit_action(:create) }
      end

      context 'sales clerk' do
        let(:user) { create(:user, role: 'sales_clerk') }

        it { should_not permit_action(:new) }
        it { should_not permit_action(:create) }
      end
    end
  end
end
