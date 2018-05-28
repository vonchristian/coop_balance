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


    def save_withdraw
      AccountingModule::Entry.create!(
        origin: find_employee.office,
        recorder: find_employee,
        commercial_document: find_time_deposit,
        description: 'Withdraw time deposit',
        reference_number: or_number,
        entry_date: date,
      debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: find_time_deposit],
      credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_time_deposit])
    end

    def credit_account
      find_employee.cash_on_hand_account
    end

    def debit_account
      find_time_deposit.time_deposit_product_account
    end

    def find_employee
      User.find_by_id(recorder_id)
    end

    def amount_is_less_than_balance
      amount.to_i <= find_time_deposit.balance
    end
    end
end
