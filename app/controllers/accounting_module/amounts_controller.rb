module AccountingModule
  class AmountsController < ApplicationController
    def destroy
      @amount = AccountingModule::Amount.find(params[:id])
      @amount.destroy
      redirect_to accounting_module_entry_url(@amount.entry), notice: 'Removed successfully.'
    end
  end
end
