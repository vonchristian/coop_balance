require 'rails_helper'

module LoansModule
  describe PredeductedInterest do
    describe 'associations' do
      it { is_expected.to have_one :entry }
      it { is_expected.to belong_to :loan }
      it { is_expected.to belong_to :credit_account }
      it { is_expected.to belong_to :debit_account }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :posting_date }
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_numericality_of :amount }
    end
  end
end
