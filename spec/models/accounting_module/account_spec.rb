require 'rails_helper'

module AccountingModule
  describe Account, type: :model do
    it '.TYPES' do
      expect(described_class::TYPES).to eql(['Asset', 'Liability', 'Equity', 'Revenue', 'Expense'])
    end

    describe 'associations' do
      it { is_expected.to belong_to(:main_account).optional }
      it { is_expected.to have_many :subsidiary_accounts }
      it { is_expected.to have_many :amounts }
      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :debit_entries }
      it { is_expected.to have_many :credit_entries }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :type }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :code }
    end
    describe 'scopes' do
      it ".assets" do
        asset     = create(:asset)
        liability = create(:liability)
        expect(described_class.assets.pluck(:id)).to include(asset.id)
        expect(described_class.assets.pluck(:id)).to_not include(liability.id)
      end
      it ".liabilities" do
        asset     = create(:asset)
        liability = create(:liability)
        expect(described_class.liabilities.pluck(:id)).to_not include(asset.id)
        expect(described_class.liabilities.pluck(:id)).to include(liability.id)
      end
      it ".equities" do
        asset     = create(:asset)
        equity    = create(:equity)
        expect(described_class.equities.pluck(:id)).to_not include(asset.id)
        expect(described_class.equities.pluck(:id)).to include(equity.id)
      end
      it ".expenses" do
        asset     = create(:asset)
        expense    = create(:expense)
        expect(described_class.expenses.pluck(:id)).to_not include(asset.id)
        expect(described_class.expenses.pluck(:id)).to include(expense.id)
      end
      it ".revenues" do
        asset     = create(:asset)
        revenue    = create(:revenue)
        expect(described_class.revenues.pluck(:id)).to_not include(asset.id)
        expect(described_class.revenues.pluck(:id)).to include(revenue.id)
      end

      it ".active" do
        active_account = create(:asset, active: true)
        inactive_account = create(:expense, active: false)

        expect(described_class.active).to include(active_account)
        expect(described_class.active).to_not include(inactive_account)
      end

      it ".inactive" do
        active_account = create(:asset, active: true)
        inactive_account = create(:expense, active: false)

        expect(described_class.inactive).to include(inactive_account)
        expect(described_class.inactive).to_not include(active_account)
      end
    end

    it ".updated_by(employee)" do
      employee  = create(:employee)
      liability = create(:liability)
      asset     = create(:asset)
      revenue   = create(:revenue)
      entry     = build(:entry, recorder: employee)
      entry.credit_amounts << build(:credit_amount, account: asset)
      entry.debit_amounts  << build(:debit_amount, account: revenue)
      entry.save

      expect(described_class.updated_by(employee)).to include(asset)
      expect(described_class.updated_by(employee)).to include(revenue)
      expect(described_class.updated_by(employee)).to_not include(liability)
    end
    it ".types" do
      expect(described_class.types).to eql  ["AccountingModule::Asset",
       "AccountingModule::Equity",
       "AccountingModule::Liability",
       "AccountingModule::Expense",
       "AccountingModule::Revenue"]
     end

    it "#account_name" do
      asset = build(:asset, name: "Cash on Hand")
      expect(asset.account_name).to eql "Cash on Hand"
    end

    let(:account) { build(:account) }
    subject { account }

    it { is_expected.to_not be_valid }  # must construct a child type instead

    describe "when using a child type" do
      let(:account) { create(:account, type: "AccountingModule::Asset") }
      it { is_expected.to be_valid }
    end

    it "calling the instance method #balance should raise a NoMethodError" do
      expect { subject.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end



    it "#set_as_inactive" do

        liability      = create(:liability)
        equity         = create(:equity)
        asset            = create(:asset)
        expense          = create(:expense)
        revenue = create(:revenue)

        ca1 = build(:credit_amount, :account => liability, :amount => 100000)
        ca2 = build(:credit_amount, :account => equity, :amount => 1000)

        da1 = build(:debit_amount, :account => asset, :amount => 100000)
        da2 = build(:debit_amount, :account => expense, :amount => 1000)

        create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])
        create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2])

        expect(liability.balance).to eql 100_000
        expect(revenue.balance).to eql 0
        expect(revenue.active?).to be true

        revenue.set_as_inactive
        liability.set_as_inactive

        expect(revenue.active?).to be false
        expect(liability.active?).to be true



    end



    describe ".trial_balance" do
      subject { described_class.trial_balance }
      it { is_expected.to be_kind_of BigDecimal }

      context "when given no entries" do
        it { is_expected.to eql 0 }
      end

      context "when given correct entries" do
        before {
          cooperative = create(:cooperative)

          # credit accounts
          liability      = create(:liability)
          equity         = create(:equity)
          revenue        = create(:revenue)
          contra_asset   = create(:asset, :contra => true)
          contra_expense = create(:expense, :contra => true)
          # credit amounts
          ca1 = build(:credit_amount, :account => liability, :amount => 100000)
          ca2 = build(:credit_amount, :account => equity, :amount => 1000)
          ca3 = build(:credit_amount, :account => revenue, :amount => 40404)
          ca4 = build(:credit_amount, :account => contra_asset, :amount => 2)
          ca5 = build(:credit_amount, :account => contra_expense, :amount => 333)

          # debit accounts
          asset            = create(:asset)
          expense          = create(:expense)
          contra_liability = create(:liability, :contra => true)
          contra_equity    = create(:equity, :contra => true)
          contra_revenue   = create(:revenue, :contra => true)
          # debit amounts
          da1 = build(:debit_amount, :account => asset, :amount => 100000)
          da2 = build(:debit_amount, :account => expense, :amount => 1000)
          da3 = build(:debit_amount, :account => contra_liability, :amount => 40404)
          da4 = build(:debit_amount, :account => contra_equity, :amount => 2)
          da5 = build(:debit_amount, :account => contra_revenue, :amount => 333)

          create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1], cooperative: cooperative, previous_entry: cooperative.entries.recent)
          create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2], cooperative: cooperative, previous_entry: cooperative.entries.recent)
          create(:entry, :credit_amounts => [ca3], :debit_amounts => [da3], cooperative: cooperative, previous_entry: cooperative.entries.recent)
          create(:entry, :credit_amounts => [ca4], :debit_amounts => [da4], cooperative: cooperative, previous_entry: cooperative.entries.recent)
          create(:entry, :credit_amounts => [ca5], :debit_amounts => [da5], cooperative: cooperative, previous_entry: cooperative.entries.recent)
        }

        it { is_expected.to eql 0 }
      end
    end
  end
end
