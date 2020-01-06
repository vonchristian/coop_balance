require 'rails_helper'

module Cooperatives
  describe Membership, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :cooperator }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :membership_category }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :cooperator_id }
      it { is_expected.to validate_presence_of(:cooperative_id) }
      it { is_expected.to validate_uniqueness_of :account_number }
      it 'validate_uniqueness_of(:cooperator_id).scoped_to(:cooperative_id)' do 
        member      = create(:member)
        cooperative = create(:cooperative)
        create(:membership, cooperator: member, cooperative: cooperative)
        membership = build(:membership, cooperator: member, cooperative: cooperative)
        membership.save

        expect(membership.errors[:cooperator_id]).to eq ['has already been taken']
      end 
      it { is_expected.to validate_presence_of :account_number }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
    end
  end
end
