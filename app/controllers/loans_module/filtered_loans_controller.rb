module LoansModule
  class FilteredLoansController < ApplicationController
    def index
      @loans = current_cooperative.loans
       @barangays = current_cooperative.barangays
    @municipalities = current_cooperative.municipalities
    @organizations = current_cooperative.organizations
    end
  end
end
