module SavingsAccounts
  class BalanceTransferVoucher
    include ActiveModel::Model
    attr_accessor :origin_saving_id, :employee_id, :description, :reference_number, :account_number, :date, :cart_id

    validates :reference_number, :date, :description, presence: true

    def process!
      return unless valid?

      ApplicationRecord.transaction do
        create_balance_transfer
        remove_cart_reference
      end
    end

    def find_voucher
      TreasuryModule::Voucher.find_by(account_number: account_number)
    end

    private

    def create_balance_transfer
      voucher =  TreasuryModule::Voucher.new(
        payee: find_origin_saving.depositor,
        office: find_office,
        cooperative: find_employee.cooperative,
        preparer: find_employee,
        description: description,
        reference_number: reference_number,
        account_number: account_number,
        date: date
      )

      find_cart.voucher_amounts.credit.each do |voucher_amount|
        voucher.voucher_amounts.credit.build(
          amount: voucher_amount.amount,
          account: voucher_amount.account
        )
      end
      voucher.voucher_amounts.debit.build(
        amount: find_cart.voucher_amounts.credit.total,
        account: find_origin_saving.liability_account
      )
      voucher.save!
    end

    def find_employee
      User.find(employee_id)
    end

    def find_office
      find_employee.office
    end

    def find_origin_saving
      find_office.savings.find(origin_saving_id)
    end

    def find_cart
      find_employee.carts.find(cart_id)
    end

    def remove_cart_reference
      find_cart.voucher_amounts.each do |amount|
        amount.cart_id = nil
        amount.save!
      end
    end
  end
end
