require 'rails_helper'

module BankAccounts
  describe EntryForm, type: :model do
    describe 'validations' do
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_numericality_of :amount }
    end
  end
end
