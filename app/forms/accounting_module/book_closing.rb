module AccountingModule
  class BookClosing
    include ActiveModel::Model 
    attr_accessor :employee_id, :date, :account_number

    validates :date, :account_number, :employee_id, presence: true 
    

    def find_voucher 
      find_office.vouchers.find_by(account_number: account_number)
    end 

    def close_book!
      ApplicationRecord.transaction do 
        create_voucher
      end 
    end 

    private 
    def create_voucher 
      voucher = find_office.vouchers.build(
        cooperative: find_office.cooperative,
        account_number: account_number,
        payee:             find_employee,
        date:             date,
        reference_number: "BOOK CLOSING - #{parsed_date.year}",
        description:      "books closing #{parsed_date.year}",
        preparer:         find_employee
      )

      create_revenue_amounts(voucher)
      create_expense_amounts(voucher)
      create_net_income_amount(voucher)

      voucher.save!
    end 

    def create_revenue_amounts(voucher)
      find_office.accounts.revenues.each do |revenue|
        balance = revenue.balance(from_date: from_date, to_date: to_date)
       
        if !balance.zero? 
          voucher.voucher_amounts.debit.build(amount: balance, account: revenue)
        end 
      end 
    end 

    def create_expense_amounts(voucher)
      find_office.accounts.expenses.each do |expense|
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
    def find_office
      find_employee.office 
    end 

    def find_employee
      User.find(employee_id)
    end

    def from_date
      DateTime.parse(date).beginning_of_year 
    end 

    def to_date
      parsed_date.end_of_year
    end 

    def parsed_date
      DateTime.parse(date)
    end 
  end 
end 