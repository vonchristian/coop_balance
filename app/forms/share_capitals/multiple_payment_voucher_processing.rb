module ShareCapitals
  class MultiplePaymentVoucherProcessing
    include ActiveModel::Model
    attr_accessor :cart_id, :date, :reference_number, :description, :employee_id, :cash_account_id, :account_number

    validates :cart_id, :date, :reference_number, :description, :employee_id, :cash_account_id, :account_number, presence: true

    def process!
      return unless valid?

      ApplicationRecord.transaction do
        create_voucher
        remove_cart_reference
      end
    end

    private

    def create_voucher
      voucher = find_office.vouchers.build(
        date: date,
        description: description,
        reference_number: reference_number,
        account_number: account_number,
        preparer: find_employee,
        cooperative: find_employee.cooperative,
        payee: find_employee
      )

      add_cart_credit_amounts(voucher)
      create_cash_amount(voucher)

      voucher.save!
    end

    def add_cart_credit_amounts(voucher)
      voucher.voucher_amounts << find_cart.voucher_amounts.credit
    end

    def create_cash_amount(voucher)
      voucher.voucher_amounts.debit.build(
        amount: find_cart.voucher_amounts.credit.total,
        account: find_cash_account
      )
    end

    def remove_cart_reference
      find_cart.voucher_amounts.each do |amount|
        amount.cart_id = nil
        amount.save!
      end
    end

    def find_office
      find_employee.office
    end

    def find_employee
      User.find(employee_id)
    end

    def find_cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end
  end
end
