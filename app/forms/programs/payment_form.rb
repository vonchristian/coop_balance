module Programs
  class PaymentForm
    include ActiveModel::Model
    attr_accessor :program_id, :recorder_id, :amount, :or_number, :date, :subscriber_id
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
    def find_subscriber
      employee_subscriber = User.find_by_id(subscriber_id)
      member_subscriber = Member.find_by_id(subscriber_id)
      if member_subscriber.present?
        member_subscriber
      elsif employee_subscriber.present?
        employee_subscriber
      end
    end

    def find_user
      User.find_by(id: recorder_id)
    end

    def save_payment
      find_program_subscription.subscription_payments.create!(recorder_id: recorder_id, description: 'Payment of program subscription', reference_number: or_number, entry_date: date,
      debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: find_subscriber],
      credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_subscriber])
    end
    def debit_account
     find_user.cash_on_hand_account
    end
    def credit_account
      find_program_subscription.account
    end
  end
end
