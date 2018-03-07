module Employees
  class ShareCapitalForm
    include ActiveModel::Model
    attr_accessor :share_capital_product_id, :subscriber_id, :account_number, :reference_number, :amount, :date, :share_capital_id, :recorder_id

    validates :reference_number, :date, :amount, presence: true
    validates :amount, numericality: true

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
      AccountingModule::Entry.create!(
        recorder_id: recorder_id,
        description: 'Payment of capital build up',
        reference_number: reference_number,
        commercial_document: share_capital,
        entry_date: date,
        debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: share_capital],
        credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: share_capital])
    end

    def debit_account
      find_employee.cash_on_hand_account
    end
    def find_subscriber
      employee_subscriber = User.find_by_id(subscriber_id)
      member_subscriber = Member.find_by_id(subscriber_id)
      if employee_subscriber.present?
        employee_subscriber
      elsif member_subscriber.present?
        member_subscriber
      end
    end

    def credit_account
      find_share_capital_product.paid_up_account
    end
    def find_share_capital_product
      CoopServicesModule::ShareCapitalProduct.find_by_id(share_capital_product_id)
    end
  end
end
