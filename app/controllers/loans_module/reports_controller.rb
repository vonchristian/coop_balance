module LoansModule
  class ReportsController < ApplicationController
    def index
      authorize [:loans_module, :reports]
    end
  end
end
