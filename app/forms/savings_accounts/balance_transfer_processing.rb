module SavingsAccounts
  class BalanceTransferProcessing
    include ActiveModel::Model
    attr_accessor :origin_id, :destination_id, :employee_id, :amount,
    :reference_number, :account_number, :date
    validates :amount, :reference_number, :date, presence: true
    
    def process!
      ActiveRecord::Base.transaction do
        create_balance_transfer
      end
    end

    def find_voucher
      Voucher.find_by(account_number: account_number)
    end

    def find_destination_saving
      MembershipsModule::Saving.find(destination_id)
    end

    private

    def create_balance_transfer
      voucher = Voucher.new(
        payee: find_origin_saving.depositor,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        preparer: find_employee,
        description: "Savings account balance transfer from #{find_origin_saving.name} to #{find_destination_saving.name}",
        reference_number: reference_number,
        account_number: account_number,
        date: date)
      voucher.voucher_amounts.debit.build(
        account: find_destination_saving.saving_product_account,
        amount: amount,
        commercial_document: find_origin_saving)
      voucher.voucher_amounts.credit.build(
        account: find_destination_saving.saving_product_account,
        amount: amount,
        commercial_document: find_destination_saving)
      voucher.save!
    end

    def find_employee
      User.find_by_id(employee_id)
    end

    def find_origin_saving
      MembershipsModule::Saving.find(origin_id)
    end

  end
end
