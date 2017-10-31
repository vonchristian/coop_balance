module Employees
  class TimeDepositForm
    include ActiveModel::Model
    attr_accessor :reference_number, :account_number, :date, :amount,:depositor_id, :depositor_type, :recorder_id, :number_of_days
    validates :depositor_id, presence: true
    def save
      ActiveRecord::Base.transaction do
        create_time_deposit
        create_entry
        set_product_for_time_deposit
      end
    end

    def create_time_deposit
      find_depositor.time_deposits.create!(account_number: account_number, number_of_days: number_of_days, date_deposited: date)
    end

    def find_depositor
      User.find_by(id: depositor_id)
    end
    def find_time_deposit
      find_depositor.time_deposits.find_by(account_number: account_number, number_of_days: number_of_days, date_deposited: date)
    end
    def find_employee
      User.find_by(id: recorder_id)
    end

    def create_entry
      find_time_deposit.deposits.time_deposit.create!(recorder_id: recorder_id, description: 'Time deposit', reference_number: reference_number, entry_date: date,
      debit_amounts_attributes: [account: find_employee.cash_on_hand_account, amount: amount],
      credit_amounts_attributes: [account: credit_account, amount: amount])
    end
    def credit_account
      AccountingModule::Account.find_by(name: "Time Deposits")
    end
    def set_product_for_time_deposit
      CoopServicesModule::TimeDepositProduct.set_product_for(find_time_deposit)
    end
  end
end
