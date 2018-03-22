require 'rails_helper'

RSpec.describe StoreFront, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :accounts_receivable_account }
    it { is_expected.to belong_to :accounts_payable_account }
    it { is_expected.to belong_to :cost_of_goods_sold_account }
    it { is_expected.to belong_to :merchandise_inventory_account }
    it { is_expected.to belong_to :sales_account }
    it { is_expected.to belong_to :sales_return_account }
    it { is_expected.to belong_to :spoilage_account }
    it { is_expected.to belong_to :sales_discount_account }


    it { is_expected.to have_many :entries }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :contact_number }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_presence_of :accounts_receivable_account_id }
    it { is_expected.to validate_presence_of :cost_of_goods_sold_account_id }
    it { is_expected.to validate_presence_of :merchandise_inventory_account_id }
    it { is_expected.to validate_presence_of :sales_account_id }
    it { is_expected.to validate_presence_of :sales_return_account_id }
    it { is_expected.to validate_presence_of :accounts_payable_account_id }
    it { is_expected.to validate_presence_of :spoilage_account_id }
    it { is_expected.to validate_uniqueness_of :accounts_receivable_account_id }
    it { is_expected.to validate_uniqueness_of :cost_of_goods_sold_account_id }
    it { is_expected.to validate_uniqueness_of :merchandise_inventory_account_id }
    it { is_expected.to validate_uniqueness_of :sales_account_id }
    it { is_expected.to validate_uniqueness_of :sales_return_account_id }
    it { is_expected.to validate_uniqueness_of :accounts_payable_account_id }
    it { is_expected.to validate_uniqueness_of :spoilage_account_id }
    it { is_expected.to validate_uniqueness_of :sales_discount_account_id }
  end

  it "#accounts_receivable_balance(customer)" do
    member = create(:member)
    store_front = create(:store_front)
    credit_sales = build(:entry, commercial_document: member)
    credit_sales.debit_amounts << create(:debit_amount, amount: 1000, account: store_front.accounts_receivable_account, commercial_document: member)
    credit_sales.credit_amounts << create(:credit_amount, amount: 1000, account: store_front.sales_account, commercial_document: member)
    credit_sales.save
    expect(store_front.accounts_receivable_balance(member)).to eql 1_000
  end

end
