module TreasuryModule
  class CashReceiptPolicy < ApplicationPolicy
    def new?
      user.cash_accounts.present? && can_receive_cash?
    end

    def create?
      new?
    end

    def can_receive_cash?
      User::TREASURY_PERSONNELS.include?(user.role.titleize)
    end
  end
end
