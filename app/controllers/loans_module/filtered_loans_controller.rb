module LoansModule
  class FilteredLoansController < ApplicationController
    def index
      @loans = LoansModule::Loan.all
       @barangays = Addresses::Barangay.all
    @municipalities = Addresses::Municipality.all
    @organizations = Organization.all
    end
  end
end
