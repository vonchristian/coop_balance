module LoansModule
  class ArchivedLoansController < ApplicationController
    def index
      @loans = LoansModule::Loan.archived.paginate(page: params[:page], per_page: 25)
    end
  end
end
