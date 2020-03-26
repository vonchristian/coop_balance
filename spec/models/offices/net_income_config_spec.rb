require 'rails_helper'

module Offices 
  describe NetIncomeConfig, type: :model do
    describe 'associations' do 
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :net_surplus_account }
      it { is_expected.to belong_to :net_loss_account }
      it { is_expected.to belong_to :total_revenue_account }
      it { is_expected.to belong_to :total_expense_account }
      it { is_expected.to belong_to :interest_on_capital_account }
      it { is_expected.to have_many :accountable_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :entries }
    end 

    describe 'validations' do 
      it 'validate_uniqueness_of(:net_surplus_account_id).scoped_to(:office_id)' do 
        office              = create(:office)
        net_surplus_account = create(:liability)
        create(:net_income_config, office: office, net_surplus_account: net_surplus_account)
        net_income_config   = build(:net_income_config, office: office, net_surplus_account: net_surplus_account)
        net_income_config.save 

        expect(net_income_config.errors[:net_surplus_account_id]).to eq ['has already been taken']
      end
      
      it 'validate_uniqueness_of(:net_loss_account_id).scoped_to(:office_id)' do 
        office            = create(:office)
        net_loss_account  = create(:liability)
        create(:net_income_config, office: office, net_loss_account: net_loss_account)
        net_income_config = build(:net_income_config, office: office, net_loss_account: net_loss_account)
        net_income_config.save 

        expect(net_income_config.errors[:net_loss_account_id]).to eq ['has already been taken']
      end
    end

    it { is_expected.to define_enum_for(:book_closing).with_values([:annually, :semi_annually, :quarterly, :monthly]) }

    it '.current' do 
      old_config = create(:net_income_config, created_at: Date.current.last_year)
      new_config = create(:net_income_config, created_at: Date.current)

      expect(described_class.current).to eq new_config
      expect(described_class.current).to_not eq old_config
    end

    it "#books_closed?(from_date, to_date)" do 
      net_income_config = create(:net_income_config)

      expect(net_income_config.books_closed?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to eql false 

      entry = build(:entry, entry_date: Date.current)
      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      expect(net_income_config.books_closed?(from_date: Date.current.beginning_of_year, to_date: Date.current.end_of_year)).to eql true 
      
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
    
    it "#total_revenues" do 
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      l1_revenue_category = create(:revenue_level_one_account_category, office: office)
      revenue             = create(:revenue, level_one_account_category: l1_revenue_category)
     
      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      entry_2 = build(:entry, entry_date: Date.current.next_year)
      entry_2.debit_amounts.build(account: cash_on_hand, amount: 20_000)
      entry_2.credit_amounts.build(account: revenue, amount: 20_000)
      entry_2.save!

      expect(net_income_config.total_revenues(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to eql 10_000
      expect(net_income_config.total_revenues(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year)).to eql 20_000
    end 

    it "#total_expenses" do 
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      l1_expense_category = create(:expense_level_one_account_category, office: office)
      expense             = create(:expense, level_one_account_category: l1_expense_category)
     
      entry = build(:entry, entry_date: Date.current)
      entry.debit_amounts.build(account: net_income_config.total_revenue_account, amount: 10_000)
      entry.credit_amounts.build(account: net_income_config.total_expense_account, amount: 5_000)
      entry.credit_amounts.build(account: net_income_config.net_surplus_account, amount: 5_000)
      entry.save!

      entry_2 = build(:entry, entry_date: Date.current.next_year)
      entry_2.debit_amounts.build(account: cash_on_hand, amount: 20_000)
      entry_2.credit_amounts.build(account: expense, amount: 20_000)
      entry_2.save!

      expect(net_income_config.total_expenses(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to eql 5_000
      expect(net_income_config.total_expenses(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year)).to eql 20_000
    end 

    it "#total_net_surplus" do 
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      l1_expense_category = create(:expense_level_one_account_category, office: office)
      expense             = create(:expense, level_one_account_category: l1_expense_category)
      l1_revenue_category = create(:revenue_level_one_account_category, office: office)
      revenue             = create(:revenue, level_one_account_category: l1_revenue_category)
     
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

      expect(net_income_config.total_net_surplus(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to eql 5_000
      puts (net_income_config.total_net_surplus(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year))
    end 

    it "#total_net_surplus" do 
      office              = create(:office)
      net_income_config   = create(:net_income_config, office: office)
      cash_on_hand        = create(:asset)
      l1_expense_category = create(:expense_level_one_account_category, office: office)
      expense             = create(:expense, level_one_account_category: l1_expense_category)
      l1_revenue_category = create(:revenue_level_one_account_category, office: office)
      revenue             = create(:revenue, level_one_account_category: l1_revenue_category)
     
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

      expect(net_income_config.total_net_loss(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to eql 5_000
      puts (net_income_config.total_net_loss(from_date: Date.current.next_year.beginning_of_year, to_date: Date.current.next_year.end_of_year))
    end 
    
  end 
end
