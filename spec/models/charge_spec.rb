require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe 'associations' do
  	it { is_expected.to belong_to :account }
    it { is_expected.to have_many :loan_charges }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :account_id }
    it { is_expected.to validate_numericality_of :amount }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:account).with_prefix }
  end

  it "#loan_amount_range" do
    charge = create(:charge, depends_on_loan_amount: true, minimum_loan_amount: 10_000, maximum_loan_amount: 100_000)

    expect(charge.loan_amount_range).to eql(10_000..100_000)
  end
end
