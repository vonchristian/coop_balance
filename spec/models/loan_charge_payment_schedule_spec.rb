require 'rails_helper'

RSpec.describe LoanChargePaymentSchedule, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :loan_charge }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_numericality_of :amount }
  end
end
