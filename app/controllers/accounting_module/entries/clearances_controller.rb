module AccountingModule
  module Entries
    class ClearancesController < ApplicationController
      def create
        @entry = AccountingModule::Entry.find(params[:entry_id])
        @entry.update_attributes!(cleared: true, cleared_at: Date.today, cleared_by: current_user)
        @entry.cleared_at = Date.today
        redirect_to accounting_module_entry_url(@entry), notice: "Entry cleared successfully."
      end
    end
  end
end
