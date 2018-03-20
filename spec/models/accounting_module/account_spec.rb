require 'rails_helper'

module AccountingModule
  describe Account, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :main_account }
      it { is_expected.to have_many :subsidiary_accounts }
      it { is_expected.to have_many :amounts }
      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :debit_entries }
      it { is_expected.to have_many :credit_entries }

    end

    it ".active" do
      active_account = create(:asset, active: true)
      inactive_account = create(:expense, active: false)

      expect(described_class.active).to include(active_account)
      expect(described_class.active).to_not include(inactive_account)
    end

    let(:account) { build(:account) }
    subject { account }

    it { is_expected.to_not be_valid }  # must construct a child type instead

    describe "when using a child type" do
      let(:account) { create(:account, type: "Finance::Asset") }
      it { is_expected.to be_valid }

      it "should be unique per name" do
        not_conflict = create(:asset, name: "Cash on Hand")
        conflict = build(:asset, name: "Cash on Hand")
        expect(conflict).to_not be_valid
        expect(conflict.errors[:name]).to eql ["has already been taken"]
      end
    end

    it "calling the instance method #balance should raise a NoMethodError" do
      expect { subject.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    it "calling the class method ::balance should raise a NoMethodError" do
      expect { subject.class.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    describe ".trial_balance" do
      subject { described_class.trial_balance }
      it { is_expected.to be_kind_of BigDecimal }

      context "when given no entries" do
        it { is_expected.to eql 0 }
      end

      context "when given correct entries" do
        before {
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
