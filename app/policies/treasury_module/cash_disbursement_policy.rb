module TreasuryModule
  class CashDisbursementPolicy < ApplicationPolicy
    def new?
      user.cash_accounts.present? && can_disburse_cash?
    end

    def create?
      new?
    end

    def can_disburse_cash?
      User::TREASURY_PERSONNELS.include?(user.role.titleize)
    end
  end
end
