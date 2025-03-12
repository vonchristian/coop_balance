require "will_paginate/array"
module TimeDeposits
  class AccountingController < ApplicationController
    def index
      @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
    end
  end
end
