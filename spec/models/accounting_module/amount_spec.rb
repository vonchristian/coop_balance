require 'rails_helper'
module AccountingModule
  describe Amount do

    subject { build(:amount) }
    it { is_expected.to_not be_valid }

    describe 'associations' do
      it { is_expected.to belong_to :entry }
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to(:commercial_document).optional }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of     :type }
      it { is_expected.to validate_presence_of     :account }
      it { is_expected.to validate_presence_of     :entry }
      it {is_expected.to monetize(:amount) }

    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
      it { is_expected.to delegate_method(:recorder).to(:entry) }
      it { is_expected.to delegate_method(:reference_number).to(:entry) }
      it { is_expected.to delegate_method(:description).to(:entry) }
      it { is_expected.to delegate_method(:entry_date).to(:entry) }
      it { is_expected.to delegate_method(:name).to(:recorder).with_prefix }
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }


    end

    context 'scopes' do
      it ".cancelled and not_cancelled scopes" do
        cooperative = create(:cooperative)

        employee = create(:user, role: 'teller', cooperative: cooperative)
        cash_on_hand = create(:asset)
        revenue = create(:revenue)
        employee.cash_accounts << cash_on_hand
        not_cancelled_entry = build(:entry, cooperative: cooperative, recorder: employee )
        not_cancelled_debit_amount = not_cancelled_entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
        not_cancelled_credit_amount = not_cancelled_entry.credit_amounts.build(amount: 1_000, account: revenue )
        not_cancelled_entry.save!

        cooperative = create(:cooperative)
        employee = create(:user, role: 'teller', cooperative: cooperative)
        cash_on_hand = create(:asset)
        revenue = create(:revenue)
        employee.cash_accounts << cash_on_hand
        cancelled_entry = build(:entry, cooperative: cooperative, recorder: employee)
        cancelled_debit_amount = cancelled_entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
        cancelled_credit_amount = cancelled_entry.credit_amounts.build(amount: 1_000, account: revenue )
        cancelled_entry.cancelled = true
        cancelled_entry.save!

        expect(described_class.cancelled).to include(cancelled_debit_amount)
        expect(described_class.cancelled).to include(cancelled_credit_amount)
        expect(described_class.cancelled).to_not include(not_cancelled_debit_amount)
        expect(described_class.cancelled).to_not include(not_cancelled_credit_amount)

        expect(described_class.not_cancelled).to_not include(cancelled_debit_amount)
        expect(described_class.not_cancelled).to_not include(cancelled_credit_amount)

        expect(described_class.not_cancelled).to include(not_cancelled_debit_amount)
        expect(described_class.not_cancelled).to include(not_cancelled_credit_amount)


      end
      it ".for_recorder(args={})" do
        cooperative = create(:cooperative)
        employee = create(:user, role: 'teller', cooperative: cooperative)
        cash_on_hand = create(:asset)
        revenue = create(:revenue)
        employee.cash_accounts << cash_on_hand
        entry = build(:entry, cooperative: cooperative, recorder: employee, office: employee.office)
        debit_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
        credit_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
        entry.save!

        expect(described_class.for_recorder(recorder_id: employee.id)).to include(debit_amount)
        expect(described_class.for_recorder(recorder_id: employee.id)).to include(credit_amount)
      end




      it ".total_cash_amount" do
        cooperative = create(:cooperative)
        employee = create(:user, role: 'teller', cooperative: cooperative)
        cash_on_hand = create(:asset)
        revenue = create(:revenue)
        employee.cash_accounts << cash_on_hand
        entry = build(:entry, cooperative: cooperative, office: employee.office, recorder: employee)
        entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
        entry.credit_amounts.build(amount: 1_000, account: revenue )
        entry.save!

        expect(described_class.total_cash_amount).to eql 1_000
      end
    end


    it "#entered_on(args={})" do
      cooperative = create(:cooperative)
      cash_on_hand = create(:asset)
      revenue = create(:revenue)

      entry = build(:entry, cooperative: cooperative, entry_date: Date.today)
      recent_debit_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      recent_credit_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
      entry.save!

      old_entry = build(:entry, cooperative: cooperative, entry_date: Date.today.yesterday)
      old_debit_amount = old_entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      old_credit_amount = old_entry.credit_amounts.build(amount: 1_000, account: revenue )
      old_entry.save!

      expect(described_class.entered_on(from_date: Date.today, to_date: Date.today)).to include(recent_debit_amount)
      expect(described_class.entered_on(from_date: Date.today, to_date: Date.today)).to include(recent_credit_amount)
      expect(described_class.entered_on(from_date: Date.today, to_date: Date.today)).to_not include(old_debit_amount)
      expect(described_class.entered_on(from_date: Date.today, to_date: Date.today)).to_not include(old_credit_amount)

      expect(described_class.entered_on(from_date: Date.today.yesterday, to_date: Date.today.yesterday)).to include(old_credit_amount)
      expect(described_class.entered_on(from_date: Date.today.yesterday, to_date: Date.today.yesterday)).to include(old_debit_amount)
      expect(described_class.entered_on(from_date: Date.today.yesterday, to_date: Date.today.yesterday)).to_not include(recent_debit_amount)
      expect(described_class.entered_on(from_date: Date.today.yesterday, to_date: Date.today.yesterday)).to_not include(recent_credit_amount)
    end

    it ".for_account(args={})" do
      cooperative = create(:cooperative)
      cash_on_hand = create(:asset)
      revenue = create(:revenue)

      entry = build(:entry, cooperative: cooperative, entry_date: Date.today )
      recent_debit_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      recent_credit_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
      entry.save!

      expect(described_class.for_account(account_id: cash_on_hand.id)).to include(recent_debit_amount)
      expect(described_class.for_account(account_id: cash_on_hand.id)).to_not include(recent_credit_amount)

      expect(described_class.for_account(account_id: revenue.id)).to include(recent_credit_amount)
      expect(described_class.for_account(account_id: revenue.id)).to_not include(recent_debit_amount)
    end


    it ".excluding_account(args={})" do
      cooperative = create(:cooperative)
      cash_on_hand = create(:asset)
      revenue = create(:revenue)
      entry = build(:entry, cooperative: cooperative, entry_date: Date.today )
      recent_debit_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      recent_credit_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
      entry.save!

      expect(described_class.excluding_account(account_id: cash_on_hand.id)).to include(recent_credit_amount)
      expect(described_class.excluding_account(account_id: cash_on_hand.id)).to_not include(recent_debit_amount)

      expect(described_class.excluding_account(account_id: revenue.id)).to include(recent_debit_amount)
      expect(described_class.excluding_account(account_id: revenue.id)).to_not include(recent_credit_amount)
    end

    it ".with_cash_accounts" do
      cooperative = create(:cooperative)
      cash_on_hand = create(:asset)
      employee = create(:teller)
      employee.cash_accounts << cash_on_hand
      revenue = create(:revenue)
      entry = build(:entry, cooperative: cooperative, entry_date: Date.today )
      cash_on_hand_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      revenue_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
      entry.save!

      expect(described_class.with_cash_accounts).to include(cash_on_hand_amount)
      expect(described_class.with_cash_accounts).to_not include(revenue_amount)

      expect(described_class.without_cash_accounts).to include(revenue_amount)
      expect(described_class.without_cash_accounts).to_not include(cash_on_hand_amount)
    end

    it ".without_cash_accounts" do
      cooperative = create(:cooperative)
      cash_on_hand = create(:asset)
      employee = create(:teller)
      employee.cash_accounts << cash_on_hand
      revenue = create(:revenue)
      entry = build(:entry, cooperative: cooperative, entry_date: Date.today )
      cash_on_hand_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      revenue_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
      entry.save!

      expect(described_class.without_cash_accounts).to include(revenue_amount)
      expect(described_class.without_cash_accounts).to_not include(cash_on_hand_amount)
    end



    it "#debit?" do
      debit_amount = build(:debit_amount)
      credit_amount = build(:credit_amount)

      expect(debit_amount.debit?).to be true
      expect(credit_amount.debit?).to be false
    end

    it "#credit?" do
      debit_amount = build(:debit_amount)
      credit_amount = build(:credit_amount)

      expect(debit_amount.credit?).to be false
      expect(credit_amount.credit?).to be true
    end

    it ".total" do
      cooperative = create(:cooperative)
      cash_on_hand = create(:asset)
      employee = create(:teller)
      employee.cash_accounts << cash_on_hand
      revenue = create(:revenue)

      entry = build(:entry, cooperative: cooperative, entry_date: Date.today )
      cash_on_hand_amount = entry.debit_amounts.build(account: cash_on_hand, amount: 1_000)
      revenue_amount = entry.credit_amounts.build(amount: 1_000, account: revenue )
      entry.save!

      expect(entry.amounts.total).to eql 2_000
      expect(entry.debit_amounts.total).to eql 1_000
      expect(entry.credit_amounts.total).to eql 1_000
    end

    describe ".balance_finder" do
      it "commercial_document" do
        expect(AccountingModule::Amount.balance_finder(commercial_document: 0)).to eql AccountingModule::BalanceFinders::CommercialDocument
      end

      it "commercial_document with to date" do
        expect(AccountingModule::Amount.balance_finder(commercial_document: 0, to_date: Date.current)).to eql AccountingModule::BalanceFinders::CommercialDocumentToDate
      end

      it "commercial_document with from and to date" do
        expect(AccountingModule::Amount.balance_finder(commercial_document: 0, from_date: Date.current, to_date: Date.current)).to eql AccountingModule::BalanceFinders::CommercialDocumentFromDateToDate
      end

      it "cooperative_service with to_date" do
        expect(AccountingModule::Amount.balance_finder(cooperative_service: 0, to_date: Date.current)).to eql AccountingModule::BalanceFinders::CooperativeServiceToDate
      end

      it "cooperative_service" do
        expect(AccountingModule::Amount.balance_finder(cooperative_service: 0)).to eql AccountingModule::BalanceFinders::CooperativeService
      end

      it "default_balance_finder" do
        expect(AccountingModule::Amount.balance_finder()).to eql AccountingModule::BalanceFinders::DefaultBalanceFinder
      end

      it "office with from_date and to_date" do
        expect(AccountingModule::Amount.balance_finder(office: 0, from_date: Date.current, to_date: Date.current)).to eql AccountingModule::BalanceFinders::FromDateOfficeToDate
      end

      it "from_date and to_date" do
        expect(AccountingModule::Amount.balance_finder(from_date: Date.current, to_date: Date.current)).to eql AccountingModule::BalanceFinders::FromDateToDate
      end
      it "office and to_date" do
        expect(AccountingModule::Amount.balance_finder(office: 0, to_date: Date.current)).to eql AccountingModule::BalanceFinders::OfficeToDate
      end
      it "to_date" do
        expect(AccountingModule::Amount.balance_finder(to_date: Date.current)).to eql AccountingModule::BalanceFinders::ToDate
      end

      it "office and cooperative_service" do
        expect(AccountingModule::Amount.balance_finder(office: 0, cooperative_service: 0)).to eql AccountingModule::BalanceFinders::CooperativeServiceOffice
      end
    end
  end
end
