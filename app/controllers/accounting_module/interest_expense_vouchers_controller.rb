module AccountingModule
  class InterestExpenseVouchersController < ApplicationController
    def show
      @voucher = TreasuryModule::Voucher.find(params[:id])
      @savings_accounts = current_cooperative.savings.has_minimum_balances
    end
  end
end
