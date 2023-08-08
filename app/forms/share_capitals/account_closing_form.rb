module ShareCapitals
  class AccountClosingForm
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    attr_accessor :share_capital_id, :amount, :closing_account_fee, :reference_number, :date, :recorder_id
    validates :amount, presence: true, numericality: true
    validates :reference_number, presence: true
    validate :amount_less_than_current_cash_on_hand?
    validate :amount_is_less_than_balance?

    def save
      ActiveRecord::Base.transaction do
        save_withdraw
      end
    end

    private
    def find_share_capital
      DepositsModule::ShareCapital.find_by_id(share_capital_id)
    end

    def find_employee
      User.find_by(id: recorder_id)
    end

    def save_withdraw
      entry = find_share_capital.capital_build_ups.create!(recorder_id: recorder_id, description: 'Closing of share capital', reference_number: reference_number, entry_date: date,
      debit_amounts_attributes: [{ account_id: debit_account_id, amount: find_share_capital.balance }],
      credit_amounts_attributes: [{account_id: credit_account_id, amount: amount}, { account_id: closing_account_id, amount: closing_account_fee}])


    end

    def closing_account_fee
      if find_share_capital.share_capital_product.has_closing_account_fee?
        find_share_capital.share_capital_product.closing_account_fee
      else
       0
      end
    end

    def closing_account_id
      find_share_capital.share_capital_product_closing_account.id
    end


    def credit_account_id
      find_employee.cash_on_hand_account_id
    end

    def debit_account_id
      find_share_capital.share_capital_product_paid_up_account.id
    end

    def amount_is_less_than_balance?
      errors[:amount] << "Amount exceeded balance"  if amount.to_i > find_share_capital.balance
    end

    def amount_less_than_current_cash_on_hand?
      errors[:amount] << "Amount exceeded current cash on hand" if amount.to_i > find_employee.cash_on_hand_account_balance
    end
  end
end
