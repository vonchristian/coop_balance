require 'rails_helper'

describe AccountScope, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :scopeable }
    it { is_expected.to belong_to :account }
  end

  describe 'validations' do
    it 'validate_uniqueness_of(:account_id).scoped_to(:scopeable_id)' do
      organization  = create(:organization)
      saving        = create(:saving)
      create(:account_scope, account: saving, scopeable: organization)
      account_scope = build(:account_scope, account: saving, scopeable: organization)
      account_scope.save

      expect(account_scope.errors[:account_id]).to eql ['has already been taken']
    end
  end
end
