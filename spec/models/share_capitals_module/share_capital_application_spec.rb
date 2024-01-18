require 'rails_helper'
module ShareCapitalsModule
  describe ShareCapitalApplication do
    describe 'attributes' do
      it { should respond_to(:subscriber_id) }
      it { should respond_to(:subscriber_type) }
      it { should respond_to(:office_id) }
      it { should respond_to(:cooperative_id) }
      it { should respond_to(:share_capital_product_id) }
      it { should respond_to(:equity_account_id) }
      it { should respond_to(:account_number) }
      it { should respond_to(:date_opened) }
    end

    describe 'associations' do
      it { should belong_to :subscriber }
      it { should belong_to :share_capital_product }
      it { should belong_to :cooperative }
      it { should belong_to :office }
      it { should belong_to :equity_account }
    end

    describe 'validations' do
      it { should validate_presence_of :subscriber_id }
      it { should validate_presence_of :subscriber_type }
      it { should validate_presence_of :share_capital_product_id }
      it { should validate_presence_of :office_id }
      it { should validate_presence_of :date_opened }
      it { should validate_presence_of :account_number }
      it { should validate_uniqueness_of :account_number }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:share_capital_product).with_prefix }
    end
  end
end
