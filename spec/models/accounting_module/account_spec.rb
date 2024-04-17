require 'rails_helper'

module AccountingModule
  describe Account, type: :model do
    let(:account) { build(:account) }

    it '.TYPES' do
      expect(described_class::TYPES).to eql(%w[Asset Liability Equity Revenue Expense])
    end

    describe 'associations' do
      it { is_expected.to belong_to :ledger }
      it { is_expected.to belong_to :office }
      it { should have_many :debit_amounts }
      it { should have_many :entries }
      it { should have_many :debit_entries }
      it { should have_many :credit_entries }
    end

    describe 'validations' do
      it { should validate_presence_of :type }
      it { should validate_presence_of :name }
      it { should validate_presence_of :code }
    end

    describe 'scopes' do
      it '.assets' do
        asset     = create(:asset)
        liability = create(:liability)
        expect(described_class.assets.pluck(:id)).to include(asset.id)
        expect(described_class.assets.pluck(:id)).not_to include(liability.id)
      end

      it '.liabilities' do
        asset     = create(:asset)
        liability = create(:liability)
        expect(described_class.liabilities.pluck(:id)).not_to include(asset.id)
        expect(described_class.liabilities.pluck(:id)).to include(liability.id)
      end

      it '.equities' do
        asset     = create(:asset)
        equity    = create(:equity)
        expect(described_class.equities.pluck(:id)).not_to include(asset.id)
        expect(described_class.equities.pluck(:id)).to include(equity.id)
      end

      it '.expenses' do
        asset = create(:asset)
        expense = create(:expense)
        expect(described_class.expenses.pluck(:id)).not_to include(asset.id)
        expect(described_class.expenses.pluck(:id)).to include(expense.id)
      end

      it '.revenues' do
        asset = create(:asset)
        revenue = create(:revenue)
        expect(described_class.revenues.pluck(:id)).not_to include(asset.id)
        expect(described_class.revenues.pluck(:id)).to include(revenue.id)
      end

      it '.active' do
        active_account = create(:asset, active: true)
        inactive_account = create(:expense, active: false)

        expect(described_class.active).to include(active_account)
        expect(described_class.active).not_to include(inactive_account)
      end

      it '.inactive' do
        active_account = create(:asset, active: true)
        inactive_account = create(:expense, active: false)

        expect(described_class.inactive).to include(inactive_account)
        expect(described_class.inactive).not_to include(active_account)
      end
    end

    it '.updated_by(employee)' do
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
      expect(described_class.updated_by(employee)).not_to include(liability)
    end

    it '.types' do
      expect(described_class.types).to eql ['AccountingModule::Asset',
                                            'AccountingModule::Equity',
                                            'AccountingModule::Liability',
                                            'AccountingModule::Expense',
                                            'AccountingModule::Revenue']
    end

    it '#account_name' do
      asset = build(:asset, name: 'Cash on Hand')
      expect(asset.account_name).to eql 'Cash on Hand'
    end

    it '#display_name' do
      asset = create(:asset)

      expect(asset.display_name).to eql 'Cash on Hand'
    end

    subject { account }

    it { should_not be_valid } # must construct a child type instead

    describe 'when using a child type' do
      let(:account) { create(:asset, type: 'AccountingModule::Asset') }

      it { should be_valid }
    end

    it 'calling the instance method #balance should raise a NoMethodError' do
      expect { subject.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    describe '.trial_balance' do
      subject { described_class.trial_balance }
      it { should be_a BigDecimal }

      context 'when given no entries' do
        it { should be_a BigDecimal }
      end

      context 'when given correct entries' do
        before {
          cooperative = create(:cooperative)

          # credit accounts
          liability      = create(:liability)
          equity         = create(:equity)
          revenue        = create(:revenue)
          contra_asset   = create(:asset, contra: true)
          contra_expense = create(:expense, contra: true)
          # credit amounts
          ca1 = build(:credit_amount, account: liability, amount: 100_000)
          ca2 = build(:credit_amount, account: equity, amount: 1000)
          ca3 = build(:credit_amount, account: revenue, amount: 40_404)
          ca4 = build(:credit_amount, account: contra_asset, amount: 2)
          ca5 = build(:credit_amount, account: contra_expense, amount: 333)

          # debit accounts
          asset            = create(:asset)
          expense          = create(:expense)
          contra_liability = create(:liability, contra: true)
          contra_equity    = create(:equity, contra: true)
          contra_revenue   = create(:revenue, contra: true)
          # debit amounts
          da1 = build(:debit_amount, account: asset, amount: 100_000)
          da2 = build(:debit_amount, account: expense, amount: 1000)
          da3 = build(:debit_amount, account: contra_liability, amount: 40_404)
          da4 = build(:debit_amount, account: contra_equity, amount: 2)
          da5 = build(:debit_amount, account: contra_revenue, amount: 333)

          create(:entry, credit_amounts: [ca1], debit_amounts: [da1], cooperative: cooperative)
          create(:entry, credit_amounts: [ca2], debit_amounts: [da2], cooperative: cooperative)
          create(:entry, credit_amounts: [ca3], debit_amounts: [da3], cooperative: cooperative)
          create(:entry, credit_amounts: [ca4], debit_amounts: [da4], cooperative: cooperative)
          create(:entry, credit_amounts: [ca5], debit_amounts: [da5], cooperative: cooperative)
        }

        it { should be 0.0 }
      end
    end
  end
end
