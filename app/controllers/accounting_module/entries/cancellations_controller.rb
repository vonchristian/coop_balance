module AccountingModule
  module Entries
    class CancellationsController < ApplicationController
      def create
        @entry = AccountingModule::Entry.find(params[:entry_id])
        @entry.update_attributes!(cancelled: true, cancelled_at: Date.today, cancelled_by: current_user)
        redirect_to accounting_module_entry_url(@entry), notice: "Entry cancelled successfully."
      end
    end
  end
end
