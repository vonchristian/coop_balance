module TimeDeposits
  class TransferProcessing
    include ActiveModel::Model
    attr_accessor :time_deposit_id, :employee_id, :saving_product_id, :account_number, :date, :cooperative_id, :description
    def process!
      ActiveRecord::Base.transaction do
        create_savings_account_application
      end
    end
    def find_voucher
      find_cooperative.vouchers.find_by(account_number: account_number)
    end
    def find_savings_account_application
      find_cooperative.savings_account_applications.find_by(account_number: account_number)
    end


    private
    def create_savings_account_application
      savings_account_application = SavingsAccountApplication.create!(
        saving_product_id: saving_product_id,
        depositor: find_time_deposit.depositor,
        date_opened: date,
        account_number: account_number,
        initial_deposit: find_time_deposit.balance,
        cooperative: find_employee.cooperative
      )
      create_voucher(savings_account_application)
    end
    def create_voucher(savings_account_application)
      voucher = Voucher.new(
        account_number: account_number,
        payee: find_time_deposit.depositor,
        preparer: find_employee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        description: description,
        reference_number: Voucher.generate_number,
        date: date
      )
      voucher.voucher_amounts.credit.build(
        cooperative: find_employee.cooperative,
        account: find_time_deposit.time_deposit_product.account,
        amount: find_time_deposit.balance
      )
      voucher.voucher_amounts.debit.build(
        cooperative: find_employee.cooperative,
        account: find_saving_product.account,
        amount: find_time_deposit.balance)
      voucher.save!
    end

    def find_time_deposit
      find_cooperative.time_deposits.find(time_deposit_id)
    end
    def find_cooperative
      Cooperative.find(cooperative_id)
    end
    def find_employee
      find_cooperative.users.find(employee_id)
    end
    def find_saving_product
      find_cooperative.saving_products.find(saving_product_id)
    end
  end
end
