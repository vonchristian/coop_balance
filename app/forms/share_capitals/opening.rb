module ShareCapitals
  class Opening
    include ActiveModel::Model
    attr_accessor :share_capital_product_id,
                  :employee_id,
                  :subscriber_id,
                  :amount,
                  :reference_number,
                  :date,
                  :description,
                  :account_number
    validates :share_capital_product_id,
              :employee_id,
              :amount,
              :reference_number,
              :description,
              :account_number,
              :date,
              :account_number,
              :subscriber_id,
              presence: true
    validates :amount, numericality: true

    def subscribe!
      ActiveRecord::Base.transaction do
        save_subscription
      end
    end

    def find_share_capital
      MembershipsModule::ShareCapital.find_by(account_number: account_number)
    end

    private
    def save_subscription
      share_capital = MembershipsModule::ShareCapital.create(
        subscriber: find_subscriber,
        account_number: account_number,
        share_capital_product: find_share_capital_product,
        date_opened: date,
        last_transaction_date: date
        )
      create_entry(share_capital)
    end
    def create_entry(share_capital)
      AccountingModule::Entry.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        recorder: find_employee,
        description: description,
        entry_date: date,
        reference_number: reference_number,
        commercial_document: find_subscriber,
        debit_amounts_attributes: [
          account: debit_account,
          amount: amount,
          commercial_document: share_capital],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount,
          commercial_document: share_capital]
        )
    end

    def find_employee
      User.find(employee_id)
    end

    def debit_account
      find_employee.cash_on_hand_account
    end

    def find_subscriber
      Subscriber.find(subscriber_id)
    end

    def credit_account
      find_share_capital_product.paid_up_account
    end

    def find_share_capital_product
      CoopServicesModule::ShareCapitalProduct.find_by_id(share_capital_product_id)
    end
  end
end
