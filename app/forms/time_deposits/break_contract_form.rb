module TimeDeposits
  class BreakContractForm
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    attr_accessor :amount, :break_contract_amount, :reference_number, :date, :recorder_id, :time_deposit_id

    validates :amount, :break_contract_amount, presence: true, numericality: true
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
      DepositsModule::TimeDeposit.find_by(id: time_deposit_id)
    end

    def find_employee
      User.find_by(id: recorder_id)
    end

    def save_withdraw
      find_time_deposit.entries.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        recorder: find_employee,
        description: "Withdraw time deposit with break contract fee",
        reference_number: reference_number,
        entry_date: date,
        commercial_document: find_time_deposit.depositor,
        debit_amounts_attributes: [ {
          account: debit_account,
          amount: find_time_deposit.amount_deposited
        } ],
        credit_amounts_attributes: [ {
          account: credit_account,
          amount: amount
        },
                                    { account: break_contract_account,
                                      amount: break_contract_amount } ]
      )
    end

    def close_account
      find_time_deposit.withdrawn!
    end

    def break_contract_account
      CoopConfigurationsModule::TimeDepositConfig.default_break_contract_account
    end

    def credit_account
      find_employee.cash_on_hand_account
    end

    def debit_account
      find_time_deposit.time_deposit_product_account
    end

    def amount_is_less_than_balance
      amount.to_i <= find_time_deposit.balance
    end
  end
end
