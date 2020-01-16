require 'rails_helper'
module ShareCapitalsModule
  describe ShareCapitalApplication do
    describe 'attributes' do
      it { is_expected.to respond_to(:subscriber_id) }
      it { is_expected.to respond_to(:subscriber_type) }
      it { is_expected.to respond_to(:office_id) }
      it { is_expected.to respond_to(:cooperative_id) }
      it { is_expected.to respond_to(:share_capital_product_id) }
      it { is_expected.to respond_to(:equity_account_id) }
      it { is_expected.to respond_to(:account_number) }
      it { is_expected.to respond_to(:date_opened) }


    end

    describe 'associations' do
      it { is_expected.to belong_to :subscriber }
      it { is_expected.to belong_to :share_capital_product }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :equity_account }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :subscriber_id }
      it { is_expected.to validate_presence_of :subscriber_type }
      it { is_expected.to validate_presence_of :share_capital_product_id }
      it { is_expected.to validate_presence_of :office_id }
      it { is_expected.to validate_presence_of :date_opened }
      it { is_expected.to validate_presence_of :account_number }
      it { is_expected.to validate_uniqueness_of :account_number }


    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:share_capital_product).with_prefix }
    end

  end
end 
