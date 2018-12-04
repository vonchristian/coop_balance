class TreasuryModuleController < ApplicationController
  def index
    @employee      = current_user
    @loan_products = current_cooperative.loan_products
  end
end
