module LoansModule
  class ReportsController < ApplicationController
    def index
      authorize %i[loans_module reports]
    end
  end
end
