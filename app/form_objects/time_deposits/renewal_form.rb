module TimeDeposits 
  class RenewalForm
    include ActiveModel::Model
    attr_accessor :or_number, :date_deposited, :amount,:member_id, :recorder_id, :number_of_days, :time_deposit_id

    def save
      ActiveRecord::Base.transaction do
        withdraw_time_deposit
        create_time_deposit
        create_entry
        set_product_for_time_deposit
      end
    end
    def withdraw_time_deposit
      find_previous_time_deposit.deposits.withdrawal.create!(recorder_id: recorder_id, description: 'Transfer balance to new time deposit', reference_number: or_number, entry_date: date_deposited,
      debit_amounts_attributes: [account: debit_account, amount: amount],
      credit_amounts_attributes: [account: credit_account, amount: amount])
    end
    def create_time_deposit
      find_member.time_deposits.create(number_of_days: number_of_days, date_deposited: date_deposited)
    end

    def find_member
      Member.find_by(id: member_id)
    end
    def find_previous_time_deposit 
      MembershipsModule::TimeDeposit.find_by(id: time_deposit_id)
    end
    def find_deposit
      MembershipsModule::TimeDeposit.find_by(number_of_days: number_of_days, date_deposited: date_deposited)
    end

    def create_entry
      find_deposit.deposits.time_deposit.create!(description: 'Renew time deposit', reference_number: or_number, entry_date: date_deposited,
      debit_amounts_attributes: [account: debit_account, amount: amount],
      credit_amounts_attributes: [account: credit_account, amount: amount])
    end
    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end
    def credit_account
      AccountingModule::Account.find_by(name: "Time Deposits")
    end
    def set_product_for_time_deposit
      CoopServicesModule::TimeDepositProduct.set_product_for(find_deposit)
    end
  end
end
