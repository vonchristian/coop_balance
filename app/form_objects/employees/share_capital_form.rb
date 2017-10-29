module Employees
  class ShareCapitalForm
    include ActiveModel::Model
    attr_accessor :share_capital_product_id, :subscriber_type, :subscriber_id, :account_number, :share_count, :reference_number, :amount, :date, :share_capital_id, :recorder_id

    def save
      ActiveRecord::Base.transaction do
        subscribe_to_share_capital
      end
    end
    def subscribe_to_share_capital
      share_capital = User.find_by(id: subscriber_id).share_capitals.create(share_capital_product_id: share_capital_product_id, account_number: account_number, date_opened: date)
      share_capital.entries.capital_build_up.create!(entry_type: 'capital_build_up', recorder_id: recorder_id, description: 'Payment of capital build up', reference_number: reference_number, entry_date: date,
      debit_amounts_attributes: [account: debit_account, amount: amount],
      credit_amounts_attributes: [account: credit_account, amount: amount])
    end

    def debit_account
      User.find_by(id: recorder_id).cash_on_hand_account
    end
    def credit_account
      AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common")
    end
  end
end
