module TimeDeposits
  class TransferProcessing
    include ActiveModel::Model
    attr_accessor :time_deposit_id, :employee_id, :reference_number, :account_number, :date, :saving_id, :description

    def process!
      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    def find_voucher
      find_office.vouchers.find_by(account_number: account_number)
    end

    private

    def create_voucher
      voucher =  TreasuryModule::Voucher.new(
        account_number: account_number,
        payee: find_time_deposit.depositor,
        preparer: find_employee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        description: description,
        reference_number: reference_number,
        date: date
      )
      voucher.voucher_amounts.debit.build(
        cooperative: find_employee.cooperative,
        account: find_time_deposit.liability_account,
        amount: find_time_deposit.balance
      )
      voucher.voucher_amounts.credit.build(
        cooperative: find_employee.cooperative,
        account: find_saving.liability_account,
        amount: find_time_deposit.balance
      )
      voucher.save!
    end

    def find_time_deposit
      find_office.time_deposits.find(time_deposit_id)
    end

    def find_employee
      User.find(employee_id)
    end

    def find_office
      find_employee.office
    end

    def find_saving
      find_office.savings.find(saving_id)
    end
  end
end
