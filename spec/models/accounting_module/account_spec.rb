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
      it { should validate_presence_of :account_type }
      it { should validate_presence_of :name }
      it { should validate_presence_of :code }
    end

    describe 'scopes' do
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
      expect(described_class.types).to eql [ 'AccountingModule::Asset',
                                            'AccountingModule::Equity',
                                            'AccountingModule::Liability',
                                            'AccountingModule::Expense',
                                            'AccountingModule::Revenue' ]
    end

    it '#account_name' do
      asset = build(:asset, name: 'Cash on Hand')
      expect(asset.account_name).to eql 'Cash on Hand'
    end

    it '#display_name' do
      ledger = create(:asset_ledger, name: "Cash on Hand")
      asset = create(:asset, ledger: ledger)

      expect(asset.display_name).to eql 'Cash on Hand'
    end

    subject { account }

    it { should_not be_valid } # must construct a child type instead

    describe 'when using a child type' do
      let(:account) { create(:asset) }

      it { should be_valid }
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
          ca1 = build(:credit_amount, account: liability, amount_cents: 100_000)
          ca2 = build(:credit_amount, account: equity, amount_cents: 1000)
          ca3 = build(:credit_amount, account: revenue, amount_cents: 40_404)
          ca4 = build(:credit_amount, account: contra_asset, amount_cents: 2)
          ca5 = build(:credit_amount, account: contra_expense, amount_cents: 333)

          # debit accounts
          asset            = create(:asset)
          expense          = create(:expense)
          contra_liability = create(:liability, contra: true)
          contra_equity    = create(:equity, contra: true)
          contra_revenue   = create(:revenue, contra: true)
          # debit amounts
          da1 = build(:debit_amount, account: asset, amount_cents: 100_000)
          da2 = build(:debit_amount, account: expense, amount_cents: 1000)
          da3 = build(:debit_amount, account: contra_liability, amount_cents: 40_404)
          da4 = build(:debit_amount, account: contra_equity, amount_cents: 2)
          da5 = build(:debit_amount, account: contra_revenue, amount_cents: 333)

          create(:entry, credit_amounts: [ ca1 ], debit_amounts: [ da1 ], cooperative: cooperative)
          create(:entry, credit_amounts: [ ca2 ], debit_amounts: [ da2 ], cooperative: cooperative)
          create(:entry, credit_amounts: [ ca3 ], debit_amounts: [ da3 ], cooperative: cooperative)
          create(:entry, credit_amounts: [ ca4 ], debit_amounts: [ da4 ], cooperative: cooperative)
          create(:entry, credit_amounts: [ ca5 ], debit_amounts: [ da5 ], cooperative: cooperative)
        }

        it { should be 0.0 }
      end
    end
  end
end
