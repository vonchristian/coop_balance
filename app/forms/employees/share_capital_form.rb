module Employees
  class ShareCapitalForm
    include ActiveModel::Model
    attr_accessor :share_capital_product_id, :subscriber_id, :account_number, :share_count, :reference_number, :amount, :date, :share_capital_id, :recorder_id

    def save
      ActiveRecord::Base.transaction do
        subscribe_to_share_capital
      end
    end
    private
    def find_employee
      User.find_by(id: recorder_id)
    end

    def subscribe_to_share_capital
      share_capital = find_subscriber.share_capitals.create(
        share_capital_product_id: share_capital_product_id,
        account_number: account_number,
        date_opened: date)
      share_capital.capital_build_ups.create!(
        recorder_id: recorder_id,
        description: 'Payment of capital build up',
        reference_number: reference_number,
        entry_date: date,
        debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: share_capital],
        credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: share_capital])
    end

    def debit_account
      find_employee.cash_on_hand_account
    end
    def find_subscriber
      User.find_by(id: subscriber_id)
    end

    def credit_account
      CoopServicesModule::ShareCapitalProduct.find_by(id: share_capital_product_id).default_paid_up_account
    end
  end
end
