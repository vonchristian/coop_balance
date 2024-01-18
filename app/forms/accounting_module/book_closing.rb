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
        payee: find_employee,
        date: date,
        reference_number: "BOOK CLOSING - #{parsed_date.year}",
        description: "books closing #{parsed_date.year}",
        preparer: find_employee
      )

      create_revenue_amounts(voucher)
      create_expense_amounts(voucher)
      create_net_income_amount(voucher)

      voucher.save!
    end

    def create_revenue_amounts(voucher)
      voucher.voucher_amounts.debit.build(amount: total_revneues, account: find_office.total_revenue_account)
    end

    def create_expense_amounts(voucher)
      voucher.voucher_amounts.debit.build(amount: total_expenses, account: find_office.total_expense_account)
    end

    def create_net_income_amount(voucher)
      net_income = voucher.voucher_amounts.credit.total - voucher.voucher_amounts.debit.total
      if net_income.positive?
        voucher.voucher_amounts.debit.build(
          amount: net_income,
          account: find_office.net_surplus_account
        )
      elsif net_income.negative?
        voucher.voucher_amounts.debit.build(
          amount: net_income.abs,
          account: find_office.net_loss_account
        )
      end
    end

    def total_revenues
      find_office.accounts.revenues.balance(from_date: date.beginning_of_year, to_date: date.end_of_year)
    end

    def total_expenses
      find_office.accounts.expenses.balance(from_date: date.beginning_of_year, to_date: date.end_of_year)
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

    def net_surplus_account
      find_office.net_surplus_account
    end
  end
end