module TimeDeposits
  class BreakContractForm
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    attr_accessor :time_deposit_id, :amount, :break_contract_amount, :reference_number, :date, :recorder_id
    validates :amount, presence: true, numericality: true
    validates :reference_number, presence: true

    def save
      ActiveRecord::Base.transaction do
        if amount_is_less_than_balance
          save_withdraw
          close_account
        else
          errors[:base] << "Amount exceed balance"
        end
      end
    end
    def find_time_deposit
      MembershipsModule::TimeDeposit.find_by(id: time_deposit_id)
    end
    def find_employee
      User.find_by(id: recorder_id)
    end

    def save_withdraw
       find_time_deposit.deposits.withdrawal.create!(recorder_id: recorder_id, description: 'Withdraw time deposit', reference_number: reference_number, entry_date: date,
      debit_amounts_attributes: [{account: debit_account, amount: find_time_deposit.balance } ],
      credit_amounts_attributes: [{account: credit_account, amount: amount}, {account: break_contract_account, amount: break_contract_amount}])
    end
    def close_account
      find_time_deposit.closed!
    end

    def break_contract_account
      AccountingModule::Account.find_by(name: "Break Contract Fees")
    end

    def credit_account
      find_employee.cash_on_hand_account
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Time Deposits")
    end

    def amount_is_less_than_balance
      amount.to_i <= find_time_deposit.balance
    end
  end
end