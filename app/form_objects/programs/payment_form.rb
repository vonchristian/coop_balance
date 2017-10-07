module Programs
  class PaymentForm
    include ActiveModel::Model
    attr_accessor :program_id, :recorder_id, :amount, :or_number, :date, :member_id
    validates :amount, presence: true, numericality: true
    validates :or_number, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_payment
      end
    end
    def find_program_subscription
      MembershipsModule::ProgramSubscription.find_by(id: program_id)
    end
    def find_user 
      User.find_by(id: recorder_id)
    end

    def save_payment
      find_program_subscription.subscription_payments.program_subscription_payment.create!(recorder_id: recorder_id, description: 'Payment of program subscription', reference_number: or_number, entry_date: date,
      debit_amounts_attributes: [account: debit_account, amount: amount],
      credit_amounts_attributes: [account: credit_account, amount: amount])
    end
    def debit_account
      if find_user.treasurer?
        AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)")
      elsif find_user.teller?
        AccountingModule::Account.find_by(name: "Cash on Hand (Cashier)")
      end
    end
    def credit_account
      AccountingModule::Account.find_by(name: "Members' Benefit and Other Funds Payable")
    end
  end
end