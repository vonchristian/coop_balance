module LoansModule
  class ArchivedLoansController < ApplicationController
    def index
      @loans = current_cooperative.loans.archived.paginate(page: params[:page], per_page: 25)
    end
  end
end
