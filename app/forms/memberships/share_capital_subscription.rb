module Memberships
  class ShareCapitalSubscription
    include ActiveModel::Model
    attr_accessor :share_capital_product_id,
                  :employee_id,
                  :membership_id,
                  :amount,
                  :reference_number,
                  :date,
                  :account_number
    validates :share_capital_product_id,
              :employee_id,
              :amount,
              :reference_number,
              :date,
              :account_number,
              :membership_id,
              presence: true
    validates :amount, numericality: true
    validate :ensure_unique_share_capital_product
    def subscribe!
      ActiveRecord::Base.transaction do
        save_subscription
      end
    end
    def find_share_capital
      MembershipsModule::ShareCapital.find_by(
        subscriber: find_subscriber,
        account_number: account_number,
        share_capital_product: find_share_capital_product,
        date_opened: date)
    end

    private
    def save_subscription
      share_capital = MembershipsModule::ShareCapital.create(
        subscriber: find_subscriber,
        account_number: account_number,
        share_capital_product: find_share_capital_product,
        date_opened: date
        )
      create_entry(share_capital)
    end
    def create_entry(share_capital)
      AccountingModule::Entry.create(
        recorder: find_employee,
        description: "Share capital subscription",
        entry_date: date,
        commercial_document: find_subscriber,
        debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: share_capital],
        credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: share_capital]
        )
    end
    def find_employee
      User.find_by_id(employee_id)
    end

    def debit_account
      find_employee.cash_on_hand_account
    end

    def find_subscriber
      Membership.find_by_id(membership_id)
    end

    def credit_account
      find_share_capital_product.paid_up_account
    end

    def find_share_capital_product
      CoopServicesModule::ShareCapitalProduct.find_by_id(share_capital_product_id)
    end
    private
    def ensure_unique_share_capital_product
      errors[:share_capital_product_id] << "Already subscribed" if find_subscriber.share_capitals.pluck(:share_capital_product_id).include?(share_capital_product_id)
    end
  end
end
