module TimeDeposits
  class EarnedInterestProcessing
    include ActiveModel::Model
    attr_accessor :amount, :or_number, :date, :recorder_id, :time_deposit_id
    def process!
      ActiveRecord::Base.transaction do
        save_earned_interest
      end
    end

    private
    def save_earned_interest
      entry = AccountingModule::Entry.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        recorder: find_employee,
        description: "Earned interests on #{date.to_date.strftime("%B %e, %Y")}",
        commercial_document: find_time_deposit,
        reference_number: or_number,
        entry_date: date,
      debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: find_time_deposit],
      credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_time_deposit])


    end
    def debit_account
      find_time_deposit.time_deposit_product_interest_expense_account
    end
    def credit_account
      find_time_deposit.time_deposit_product_account
    end
    def find_time_deposit
      MembershipsModule::TimeDeposit.find_by(id: time_deposit_id)
    end

    def find_employee
      User.find_by(id: recorder_id)
    end
  end
end
