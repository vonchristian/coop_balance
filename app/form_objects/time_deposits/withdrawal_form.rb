module TimeDeposits 
  class WithdrawalForm 
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    attr_accessor :amount, :or_number, :date, :recorder_id, :time_deposit_id
    validates :amount, presence: true, numericality: true
    validates :or_number, presence: true

    def save
      ActiveRecord::Base.transaction do
        if amount_is_less_than_balance
          save_withdraw
        else 
          false
        end
      end
    end
    def find_time_deposit
      MembershipsModule::TimeDeposit.find_by(id: time_deposit_id)
    end
    def find_user
      User.find_by(id: recorder_id)
    end

    def save_withdraw
      find_time_deposit.deposits.withdrawal.create!(recorder_id: recorder_id, description: 'Withdraw time deposit', reference_number: or_number, entry_date: date,
      debit_amounts_attributes: [account: debit_account, amount: amount],
      credit_amounts_attributes: [account: credit_account, amount: amount])
    end
    def credit_account
      find_user.cash_on_hand_account
    end
    def debit_account
      AccountingModule::Account.find_by(name: "Time Deposits")
    end

    def amount_is_less_than_balance
      amount.to_i <= find_time_deposit.balance
    end
    end 
end 