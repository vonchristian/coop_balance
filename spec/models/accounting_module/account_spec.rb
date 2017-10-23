require 'rails_helper'
module AccountingModule
  describe Account, type: :model do
    let(:account) { build(:account) }
    subject { account }

    it { is_expected.to_not be_valid }  # must construct a child type instead

    describe "when using a child type" do
      let(:account) { FactoryBot.create(:account, type: "Finance::Asset") }
      it { is_expected.to be_valid }

      it "should be unique per name" do
        conflict = FactoryBot.build(:account, name: account.name, type: account.type)
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
      subject { Account.trial_balance }
      it { is_expected.to be_kind_of BigDecimal }

      context "when given no entries" do
        it { is_expected.to eql 0 }
      end

      context "when given correct entries" do
        before {
          # credit accounts
          liability = FactoryBot.create(:liability)
          equity = FactoryBot.create(:equity)
          revenue = FactoryBot.create(:revenue)
          contra_asset = FactoryBot.create(:asset, :contra => true)
          contra_expense = FactoryBot.create(:expense, :contra => true)
          # credit amounts
          ca1 = FactoryBot.build(:credit_amount, :account => liability, :amount => 100000)
          ca2 = FactoryBot.build(:credit_amount, :account => equity, :amount => 1000)
          ca3 = FactoryBot.build(:credit_amount, :account => revenue, :amount => 40404)
          ca4 = FactoryBot.build(:credit_amount, :account => contra_asset, :amount => 2)
          ca5 = FactoryBot.build(:credit_amount, :account => contra_expense, :amount => 333)

          # debit accounts
          asset = FactoryBot.create(:asset)
          expense = FactoryBot.create(:expense)
          contra_liability = FactoryBot.create(:liability, :contra => true)
          contra_equity = FactoryBot.create(:equity, :contra => true)
          contra_revenue = FactoryBot.create(:revenue, :contra => true)
          # debit amounts
          da1 = FactoryBot.build(:debit_amount, :account => asset, :amount => 100000)
          da2 = FactoryBot.build(:debit_amount, :account => expense, :amount => 1000)
          da3 = FactoryBot.build(:debit_amount, :account => contra_liability, :amount => 40404)
          da4 = FactoryBot.build(:debit_amount, :account => contra_equity, :amount => 2)
          da5 = FactoryBot.build(:debit_amount, :account => contra_revenue, :amount => 333)

          FactoryBot.create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])
          FactoryBot.create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2])
          FactoryBot.create(:entry, :credit_amounts => [ca3], :debit_amounts => [da3])
          FactoryBot.create(:entry, :credit_amounts => [ca4], :debit_amounts => [da4])
          FactoryBot.create(:entry, :credit_amounts => [ca5], :debit_amounts => [da5])
        }

        it { is_expected.to eql 0 }
      end
    end
  end
end
