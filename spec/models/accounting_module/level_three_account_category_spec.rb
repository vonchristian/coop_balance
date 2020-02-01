require 'rails_helper'

module AccountingModule
  describe LevelThreeAccountCategory, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to(:level_four_account_category).optional }
      it { is_expected.to have_many :level_two_account_categories }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :debit_entries }
      it { is_expected.to have_many :credit_entries }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :type }
      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_presence_of :title }
      it 'unique code scope to office' do
        office = create(:office)
        create(:asset_level_three_account_category, office: office, code: 'test')
        l3_account_category = build(:asset_level_three_account_category, office: office, code: 'test')
        l3_account_category.save

        expect(l3_account_category.errors[:code]).to eql ['has already been taken']
      end

      it 'unique title scope to office' do
        office = create(:office)
        create(:asset_level_three_account_category, office: office, title: 'test')
        l3_account_category = build(:asset_level_three_account_category, office: office, title: 'test')
        l3_account_category.save

        expect(l3_account_category.errors[:title]).to eql ['has already been taken']
      end

    end

    it '.level_two_account_categories' do
      l3_account_category   = create(:asset_level_three_account_category)
      l2_account_category_1 = create(:asset_level_two_account_category, level_three_account_category: l3_account_category)
      l2_account_category_2 = create(:asset_level_two_account_category, level_three_account_category: l3_account_category)
      l2_account_category_3 = create(:asset_level_two_account_category)

      expect(described_class.level_two_account_categories).to include(l2_account_category_1)
      expect(described_class.level_two_account_categories).to include(l2_account_category_2)
      expect(described_class.level_two_account_categories).to_not include(l2_account_category_3)
    end

    describe 'scopes' do
      let(:asset)     { create(:asset_level_three_account_category) }
      let(:liability) { create(:liability_level_three_account_category) }
      let(:equity)    { create(:equity_level_three_account_category) }
      let(:revenue)   { create(:revenue_level_three_account_category) }
      let(:expense)   { create(:expense_level_three_account_category) }

      it 'assets' do
        expect(described_class.assets).to include(asset)
        expect(described_class.assets).to_not include(liability)
        expect(described_class.assets).to_not include(equity)
        expect(described_class.assets).to_not include(revenue)
        expect(described_class.assets).to_not include(expense)
      end

      it 'liabilities' do
        expect(described_class.liabilities).to_not include(asset)
        expect(described_class.liabilities).to include(liability)
        expect(described_class.liabilities).to_not include(equity)
        expect(described_class.liabilities).to_not include(revenue)
        expect(described_class.liabilities).to_not include(expense)
      end

      it 'equities' do
        expect(described_class.equities).to_not include(asset)
        expect(described_class.equities).to_not include(liability)
        expect(described_class.equities).to include(equity)
        expect(described_class.equities).to_not include(revenue)
        expect(described_class.equities).to_not include(expense)
      end

      it 'revenues' do
        expect(described_class.revenues).to_not include(asset)
        expect(described_class.revenues).to_not include(liability)
        expect(described_class.revenues).to_not include(equity)
        expect(described_class.revenues).to include(revenue)
        expect(described_class.revenues).to_not include(expense)
      end
      it 'expenses' do
        expect(described_class.expenses).to_not include(asset)
        expect(described_class.expenses).to_not include(liability)
        expect(described_class.expenses).to_not include(equity)
        expect(described_class.expenses).to_not include(revenue)
        expect(described_class.expenses).to include(expense)
      end
    end

    it 'types' do
      expect(described_class.types).to eql(
        ["AccountingModule::AccountCategories::LevelThreeAccountCategories::Asset",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Equity",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Expense",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Revenue"])
    end

    it '#balance' do
      office = create(:office)
      liability_level_three_account_category = create(:liability_level_three_account_category, office: office)
      liability_level_two_account_category   = create(:liability_level_two_account_category, office: office, level_three_account_category: liability_level_three_account_category)
      liability_level_one_account_category   = create(:liability_level_one_account_category, office: office, level_two_account_category: liability_level_two_account_category)
      liability                              = create(:liability, level_one_account_category: liability_level_one_account_category)
      ca1                                    = build(:credit_amount, :account => liability, :amount => 100_000)
      asset_level_one_account_category       = create(:asset_level_one_account_category, office: office)
      asset                                  = create(:asset, level_one_account_category: asset_level_one_account_category)
      da1                                    = build(:debit_amount, :account => asset, :amount => 100_000)
      create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])

      expect(liability_level_three_account_category.balance).to eql 100_000
      end


    describe ".trial_balance" do
      subject { described_class.trial_balance }
      it { is_expected.to be_kind_of BigDecimal }

      context "when given no entries" do
        it { is_expected.to eql 0 }
      end

      context "when given correct entries" do
        before {
          office = create(:office)
          liability_level_three_account_category      = create(:liability_level_three_account_category, office: office)
          equity_level_three_account_category         = create(:equity_level_three_account_category, office: office)
          revenue_level_three_account_category        = create(:revenue_level_three_account_category, office: office)
          contra_asset_level_three_account_category   = create(:asset_level_three_account_category, contra: true, office: office)
          contra_expense_level_three_account_category = create(:expense_level_three_account_category, contra: true, office: office)

          liability_level_two_account_category      = create(:liability_level_two_account_category, office: office, level_three_account_category: liability_level_three_account_category)
          equity_level_two_account_category         = create(:equity_level_two_account_category, office: office, level_three_account_category: equity_level_three_account_category)
          revenue_level_two_account_category        = create(:revenue_level_two_account_category, office: office, level_three_account_category: revenue_level_three_account_category)
          contra_asset_level_two_account_category   = create(:asset_level_two_account_category, contra: true, office: office, level_three_account_category: contra_asset_level_three_account_category)
          contra_expense_level_two_account_category = create(:expense_level_two_account_category, contra: true, office: office, level_three_account_category:   contra_expense_level_three_account_category)

          liability_level_one_account_category      = create(:liability_level_one_account_category, office: office, level_two_account_category: liability_level_two_account_category)
          equity_level_one_account_category         = create(:equity_level_one_account_category, office: office, level_two_account_category: equity_level_two_account_category)
          revenue_level_one_account_category        = create(:revenue_level_one_account_category, office: office, level_two_account_category: revenue_level_two_account_category)
          contra_asset_level_one_account_category   = create(:asset_level_one_account_category, contra: true, office: office, level_two_account_category:   contra_asset_level_two_account_category)
          contra_expense_level_one_account_category = create(:expense_level_one_account_category, contra: true, office: office, level_two_account_category: contra_expense_level_two_account_category)
          # credit accounts

          liability      = create(:liability,level_one_account_category: liability_level_one_account_category)
          equity         = create(:equity, level_one_account_category: equity_level_one_account_category)
          revenue        = create(:revenue, level_one_account_category: revenue_level_one_account_category)
          contra_asset   = create(:asset, :contra => true, level_one_account_category: contra_asset_level_one_account_category)
          contra_expense = create(:expense, :contra => true, level_one_account_category: contra_expense_level_one_account_category)
          # credit amounts
          ca1 = build(:credit_amount, :account => liability, :amount => 100000)
          ca2 = build(:credit_amount, :account => equity, :amount => 1000)
          ca3 = build(:credit_amount, :account => revenue, :amount => 40404)
          ca4 = build(:credit_amount, :account => contra_asset, :amount => 2)
          ca5 = build(:credit_amount, :account => contra_expense, :amount => 333)

          # debit accounts
          asset_level_three_account_category            = create(:asset_level_three_account_category, office: office)
          expense_level_three_account_category          = create(:expense_level_three_account_category, office: office)
          contra_liability_level_three_account_category = create(:liability_level_three_account_category, contra: true, office: office)
          contra_equity_level_three_account_category    = create(:equity_level_three_account_category, contra: true, office: office)
          contra_revenue_level_three_account_category   = create(:revenue_level_three_account_category, contra: true, office: office)

          asset_level_two_account_category            = create(:asset_level_two_account_category, office: office, level_three_account_category: asset_level_three_account_category)
          expense_level_two_account_category          = create(:expense_level_two_account_category, office: office, level_three_account_category:   expense_level_three_account_category)
          contra_liability_level_two_account_category = create(:liability_level_two_account_category, contra: true, office: office, level_three_account_category: contra_liability_level_three_account_category)
          contra_equity_level_two_account_category    = create(:equity_level_two_account_category, contra: true, office: office, level_three_account_category: contra_equity_level_three_account_category)
          contra_revenue_level_two_account_category   = create(:revenue_level_two_account_category, contra: true, office: office, level_three_account_category: contra_revenue_level_three_account_category)

          asset_level_one_account_category            = create(:asset_level_one_account_category, office: office, level_two_account_category: asset_level_two_account_category)
          expense_level_one_account_category          = create(:expense_level_one_account_category, office: office, level_two_account_category: expense_level_two_account_category)
          contra_liability_level_one_account_category = create(:liability_level_one_account_category, contra: true, office: office, level_two_account_category: contra_liability_level_two_account_category)
          contra_equity_level_one_account_category    = create(:equity_level_one_account_category, contra: true, office: office, level_two_account_category: contra_equity_level_two_account_category)
          contra_revenue_level_one_account_category   = create(:revenue_level_one_account_category, contra: true, office: office, level_two_account_category: contra_revenue_level_two_account_category)

          asset            = create(:asset, level_one_account_category: asset_level_one_account_category)
          expense          = create(:expense, level_one_account_category: expense_level_one_account_category)
          contra_liability = create(:liability, :contra => true, level_one_account_category: contra_liability_level_one_account_category)
          contra_equity    = create(:equity, :contra => true, level_one_account_category: contra_equity_level_one_account_category)
          contra_revenue   = create(:revenue, :contra => true, level_one_account_category: contra_revenue_level_one_account_category)
          # debit amounts
          da1 = build(:debit_amount, :account => asset, :amount => 100000)
          da2 = build(:debit_amount, :account => expense, :amount => 1000)
          da3 = build(:debit_amount, :account => contra_liability, :amount => 40404)
          da4 = build(:debit_amount, :account => contra_equity, :amount => 2)
          da5 = build(:debit_amount, :account => contra_revenue, :amount => 333)

          create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])
          create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2])
          create(:entry, :credit_amounts => [ca3], :debit_amounts => [da3])
          create(:entry, :credit_amounts => [ca4], :debit_amounts => [da4])
          create(:entry, :credit_amounts => [ca5], :debit_amounts => [da5])
        }

        it { is_expected.to eql 0 }
      end
    end
  end
end
