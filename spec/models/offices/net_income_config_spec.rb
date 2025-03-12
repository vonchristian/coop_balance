require 'rails_helper'

module Offices
  describe NetIncomeConfig, type: :model do
    describe 'associations' do
      it { should belong_to :office }
      it { should belong_to :net_surplus_account }
      it { should belong_to :net_loss_account }
      it { should belong_to :total_revenue_account }
      it { should belong_to :total_expense_account }
      it { should belong_to :interest_on_capital_account }
      it { should have_many :entries }
    end

    describe 'validations' do
      it 'validate_uniqueness_of(:net_surplus_account_id).scoped_to(:office_id)' do
        office              = create(:office)
        net_surplus_account = create(:liability)
        create(:net_income_config, office: office, net_surplus_account: net_surplus_account)
        net_income_config = build(:net_income_config, office: office, net_surplus_account: net_surplus_account)
        net_income_config.save

        expect(net_income_config.errors[:net_surplus_account_id]).to eq [ 'has already been taken' ]
      end

      it 'validate_uniqueness_of(:net_loss_account_id).scoped_to(:office_id)' do
        office            = create(:office)
        net_loss_account  = create(:liability)
        create(:net_income_config, office: office, net_loss_account: net_loss_account)
        net_income_config = build(:net_income_config, office: office, net_loss_account: net_loss_account)
        net_income_config.save

        expect(net_income_config.errors[:net_loss_account_id]).to eq [ 'has already been taken' ]
      end

      it 'validate_uniqueness_of(:interest_on_capital_account_id).scoped_to(:office_id)' do
        office            = create(:office)
        ioc_account       = create(:liability)
        create(:net_income_config, office: office, interest_on_capital_account: ioc_account)
        net_income_config = build(:net_income_config, office: office, interest_on_capital_account: ioc_account)
        net_income_config.save

        expect(net_income_config.errors[:interest_on_capital_account_id]).to eq [ 'has already been taken' ]
      end
    end

    it { should define_enum_for(:book_closing).with_values(%i[annually semi_annually quarterly monthly]) }

    it '.current' do
      old_config = create(:net_income_config, created_at: Date.current.last_year)
      new_config = create(:net_income_config, created_at: Date.current)

      expect(described_class.current).to eq new_config
      expect(described_class.current).not_to eq old_config
    end

    it '#books_closed?(from_date, to_date)' do
      net_income_config = create(:net_income_config)

      expect(net_income_config.books_closed?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to be false

      build(:entry, entry_date: Date.current)
      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      expect(net_income_config.books_closed?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to be true
      expect(net_income_config.books_closed?(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year)).to be false
    end

    it '#date_setter' do
      annually      = create(:net_income_config, book_closing: 'annually')
      semi_annually = create(:net_income_config, book_closing: 'semi_annually')
      quarterly     = create(:net_income_config, book_closing: 'quarterly')
      monthly       = create(:net_income_config, book_closing: 'monthly')

      expect(annually.date_setter).to eq      NetIncomeConfigs::DateSetters::Annually
      expect(semi_annually.date_setter).to eq NetIncomeConfigs::DateSetters::SemiAnnually
      expect(quarterly.date_setter).to eq     NetIncomeConfigs::DateSetters::Quarterly
      expect(monthly.date_setter).to eq       NetIncomeConfigs::DateSetters::Monthly
    end

    it '#total_revenues' do
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      revenue             = create(:revenue)

      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      entry_2 = build(:entry, entry_date: Date.current.next_year)
      entry_2.debit_amounts.build(account: cash_on_hand, amount: 20_000)
      entry_2.credit_amounts.build(account: revenue, amount: 20_000)
      entry_2.save!

      expect(net_income_config.total_revenues(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to be 10_000
      expect(net_income_config.total_revenues(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year)).to be 20_000
    end

    it '#total_expenses' do
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      expense             = create(:expense)

      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      entry_2 = build(:entry, entry_date: Date.current.next_year)
      entry_2.debit_amounts.build(account: cash_on_hand, amount: 20_000)
      entry_2.credit_amounts.build(account: expense, amount: 20_000)
      entry_2.save!

      expect(net_income_config.total_expenses(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to be 5_000
      expect(net_income_config.total_expenses(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year)).to be 20_000
    end

    it '#total_net_surplus' do
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      expense             = create(:expense)
      revenue             = create(:revenue)

      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      entry_2 = build(:entry, entry_date: Date.current.next_year)
      entry_2.credit_amounts.build(account: revenue, amount: 20_000)
      entry_2.debit_amounts.build(account: cash_on_hand, amount: 10_000)
      entry_2.debit_amounts.build(account: expense, amount: 10_000)
      entry_2.save!

      expect(net_income_config.total_net_surplus(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to be 5_000
      puts(net_income_config.total_net_surplus(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year))
    end

    it '#total_net_surplus' do
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      expense             = create(:expense)
      revenue             = create(:revenue)

      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 10_000)
      entry.debit_amounts.build(account: net_income_config.net_loss_account, amount: 5_000)
      entry.save!

      entry_2 = build(:entry, entry_date: Date.current.next_year)
      entry_2.credit_amounts.build(account: revenue, amount: 10_000)
      entry_2.credit_amounts.build(account: cash_on_hand, amount: 10_000)
      entry_2.debit_amounts.build(account: expense, amount: 20_000)
      entry_2.save!

      expect(net_income_config.total_net_loss(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to be 5_000
      puts(net_income_config.total_net_loss(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year))
    end
  end
end
