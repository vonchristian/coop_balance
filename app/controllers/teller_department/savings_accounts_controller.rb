module TellerDepartment
  class SavingsAccountsController < ApplicationController
    def index
      @savings_accounts = Saving.all
    end
  end
end
