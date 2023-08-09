module AccountingModule
  module Entries
    class CancellationsController < ApplicationController
      def new
        @entry = current_cooperative.entries.find(params[:entry_id])
        @cancellation = AccountingModule::Entries::CancellationProcessing.new
        authorize [:accounting_module, :entries, :cancellation]
      end

      def create
        @entry = current_cooperative.entries.find(params[:entry_id])
        @cancellation = AccountingModule::Entries::CancellationProcessing.new(cancellation_params)
        authorize [:accounting_module, :entries, :cancellation]
        if @cancellation.valid?
          @cancellation.process!
          redirect_to accounting_module_entry_url(@entry), notice: "Entry cancelled successfully."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def cancellation_params
        params.require(:accounting_module_entries_cancellation_processing).
        permit(:cancelled_at, :cancelled_by_id, :cancellation_description, :entry_id)
      end
    end
  end
end
