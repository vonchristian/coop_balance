module AccountingModule
  class BookClosing
    include ActiveModel::Model 
    attr_reader :employee, :date, :office, :net_income_account

    validates :employee, :date, :account_number, presence: true 
    
    def initialize(employee:, date:, account_number:)
      @employee           = employee
      date                = date 
      @office             = @employee.office 
      @account_number     = account_number
      @net_income_account = @office.net_income_account
    end 

    def find_voucher 
      office.vouchers.find_by(account_number: account_number)
    end 

    def close_book!
      ApplicationRecord.transaction do 
        create_voucher
      end 
    end 

    private 
    def create_voucher 
      voucher = office.vouchers.build(
        date:             date,
        reference_number: "BOOK CLOSING - #{date.year}",
        description:      "books closing #{date.year}",
        preparer:         employee
      )

      create_revenue_amounts(voucher)
      create_expense_amounts(voucher)
      create_net_income_amount(voucher)

      voucher.save!
    end 

    def create_revenue_amounts(voucher)
      office.accounts.revenues.each do |revenue|
        balance = revenue.balance(from_date: from_date, to_date: to_date)
       
        if !balance.zero? 
          voucher.voucher_amounts.debit.build(amount: balance, account: revenue)
        end 
      end 
    end 

    def create_expense_amounts(voucher)
      office.accounts.expenses.each do |expense|
        balance = expense.balance(from_date: from_date, to_date: to_date)
        
        if !balance.zero? 
          voucher.voucher_amounts.debit.build(amount: balance, account: expense)
        end 
      end 
    end 

    def create_net_income_amount(voucher)
      net_income = voucher.voucher_amounts.credit.total - voucher.voucher_amounts.debit.total
      if net_income.positive?
        voucher.voucher_amounts.debit.build(amount: net_income, account: net_income_account)
      elsif net_income.negative?
        voucher.voucher_amounts.credit.build(amount: net_income, account: net_income_account)
      end
    end 

  end 
end 