module AccountingModule
  module ScheduledEntries
    class BookClosingConfirmationsController < ApplicationController
      def show
        @voucher = current_office.vouchers.find(params[:id])
      end
    end
  end
end
