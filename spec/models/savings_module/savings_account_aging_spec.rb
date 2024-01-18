require 'rails_helper'

module SavingsModule
  describe SavingsAccountAging do
    describe 'associations' do
      it { should belong_to :savings_account }
      it { should belong_to :savings_aging_group }
    end

    describe 'validations' do
      it { should validate_presence_of :date }
    end

    it '.current' do
      old_aging = create(:savings_account_aging, date: Date.current.last_month)
      new_aging = create(:savings_account_aging, date: Date.current)

      expect(described_class.current).to eql new_aging
      expect(described_class.current).not_to eql old_aging
    end
  end
end
