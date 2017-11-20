module LoansModule
  class PaymentPolicy < ApplicationPolicy
    def new?
      user.cash_on_hand_account.present? && record.disbursed?
    end
    def create?
      new?
    end
  end
end
