require 'rails_helper'

module Cooperatives
  describe Membership do
    describe 'associations' do
      it { is_expected.to belong_to :cooperator }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :cooperator_id }
      it { is_expected.to validate_presence_of(:cooperative_id) }
      it { is_expected.to validate_uniqueness_of :account_number }
      it { is_expected.to validate_uniqueness_of(:cooperator_id).scoped_to(:cooperative_id) }
      it { is_expected.to validate_presence_of :account_number }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:avatar).to(:cooperator) }
      it { is_expected.to delegate_method(:name).to(:cooperator).with_prefix }
      it { is_expected.to delegate_method(:savings).to(:cooperator) }
      it { is_expected.to delegate_method(:share_capitals).to(:cooperator) }
      it { is_expected.to delegate_method(:account_receivable_store_balance).to(:cooperator) }
      it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
    end
  end
end
