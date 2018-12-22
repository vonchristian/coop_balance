module TimeDeposits
  class WithdrawalForm
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    attr_accessor :amount, :or_number, :date, :recorder_id, :time_deposit_id, :cash_account_id
    validates :amount, presence: true, numericality: true
    validates :or_number, presence: true

    def save
      ActiveRecord::Base.transaction do
        if amount_is_less_than_balance
          save_withdraw
          set_time_deposit_as_withdrawn
        else
          false
        end
      end
    end
    def find_time_deposit
      MembershipsModule::TimeDeposit.find_by(id: time_deposit_id)
    end


    def save_withdraw
      entry = AccountingModule::Entry.create!(
        office:              find_employee.office,
        cooperative:         find_employee.cooperative,
        recorder:            find_employee,
        commercial_document: find_time_deposit,
        description:         'Withdraw time deposit',
        reference_number:    or_number,
        entry_date:          date,
        debit_amounts_attributes: [
          account:             debit_account, 
          amount:              amount, 
          commercial_document: find_time_deposit
        ],
        credit_amounts_attributes: [
          account:             cash_account, 
          amount:              amount, 
          commercial_document: find_time_deposit
        ]
      )
    end

    def set_time_deposit_as_withdrawn
      find_time_deposit.update(withdrawn: true)
    end

    def cash_account
      AccountingModule::Account.find(cash_account_id)
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
