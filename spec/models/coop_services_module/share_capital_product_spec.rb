require 'rails_helper'

module CoopServicesModule
	describe ShareCapitalProduct do
	  context 'associations' do
      it { is_expected.to belong_to :paid_up_account }
      it { is_expected.to belong_to :closing_account }
      it { is_expected.to belong_to :subscription_account }
      it { is_expected.to belong_to :interest_payable_account }
	  	it { is_expected.to have_many :subscribers }
	  end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :paid_up_account_id }
      it { is_expected.to validate_presence_of :subscription_account_id }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :cost_per_share }
      it { is_expected.to validate_presence_of :minimum_number_of_paid_share }
      it { is_expected.to validate_presence_of :minimum_number_of_subscribed_share }
      it { is_expected.to validate_numericality_of :cost_per_share }
      it { is_expected.to validate_numericality_of :minimum_number_of_paid_share }
      it { is_expected.to validate_numericality_of :minimum_number_of_subscribed_share }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:paid_up_account).with_prefix }
      it { is_expected.to delegate_method(:name).to(:subscription_account).with_prefix }
    end

    it "#minimum_payment" do
      share_capital_product = build(:share_capital_product, cost_per_share: 100, minimum_number_of_paid_share: 10)

      expect(share_capital_product.minimum_payment).to eql 1_000
    end
	end
end
