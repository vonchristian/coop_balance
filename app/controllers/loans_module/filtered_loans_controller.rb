module LoansModule
  class FilteredLoansController < ApplicationController
    def index
      @loans = current_cooperative.loans
      @municipalities = current_cooperative.municipalities
      @organizations = current_cooperative.organizations
    end
  end
end
