module Vouchers
  class VoucherProcessing
    include ActiveModel::Model
    attr_accessor :date, :reference_number, :description, :payee_id, :employee_id, :cooperative_service_id, :account_number, :cash_account_id, :cart_id

    validates :date, :description, :payee_id, :reference_number, presence: true

    def process!
      ActiveRecord::Base.transaction do
        create_voucher
        remove_employee_reference
      end
    end

    def find_voucher
      TreasuryModule::Voucher.find_by(account_number: account_number)
    end

    private

    def create_voucher
      voucher =  TreasuryModule::Voucher.create!(
        payee: find_payee,
        cooperative_service_id: cooperative_service_id,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        preparer: find_employee,
        description: description,
        reference_number: reference_number,
        account_number: account_number,
        date: date
      )
      voucher.voucher_amounts << find_cart.voucher_amounts
    end

    def find_employee
      User.find(employee_id)
    end

    def find_payee
      Payee.find_by_id(payee_id) # rubocop:disable Rails/DynamicFindBy
    end

    def find_cart
      find_employee.carts.find_by(id: cart_id)
    end

    def remove_employee_reference
      find_employee.voucher_amounts.each do |voucher_amount|
        voucher_amount.recorder_id = nil
        voucher_amount.save
      end
      return if find_cart.blank?

      find_cart.voucher_amounts.each do |voucher_amount|
        voucher_amount.cart_id = nil
        voucher_amount.save
      end
      find_cart.update(customer: nil)
    end
  end
end
