
module ShareCapitals
  class BalanceTransferProcessing
    include ActiveModel::Model

    attr_accessor :origin_id, :destination_id, :amount, :date, :employee_id, :reference_number, :account_number, :description
    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :date, presence: true
    validate :amount_is_less_than_or_equal_to_balance?

    def process!
      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    def find_voucher
      Voucher.find_by(account_number: account_number)
    end
    def find_destination_share_capital
      MembershipsModule::ShareCapital.find(destination_id)
    end

    private
    def create_voucher
      voucher = Voucher.new(
      account_number: account_number,
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      preparer: find_employee,
      description: "Balance transfer from #{find_origin.name} to #{find_destination.name}",
      reference_number: reference_number,
      payee: find_destination.subscriber,
      date: date
    )
    voucher.voucher_amounts.debit.build(
        account: find_origin.share_capital_product_paid_up_account,
        amount: amount,
        commercial_document: find_origin
    )

    voucher.voucher_amounts.credit.build(
        account: find_destination.share_capital_product_paid_up_account,
        amount: amount,
        commercial_document: find_destination
    )
    voucher.save!
    end

    def find_employee
      User.find(employee_id)
    end
    def find_origin
      MembershipsModule::ShareCapital.find(origin_id)
    end

    def find_destination
      MembershipsModule::ShareCapital.find(destination_id)
    end

    def amount_is_less_than_or_equal_to_balance?
      errors[:amount] << "exceeded available balance" if amount.to_f > find_origin.paid_up_balance
    end
  end
end
