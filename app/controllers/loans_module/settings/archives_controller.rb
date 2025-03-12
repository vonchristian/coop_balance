module LoansModule
  module Settings
    class ArchivesController < ApplicationController
      def new
        @cooperative = current_cooperative
        @from_date = params[:from_date] ? Date.parse(params[:from_date]) : current_cooperative.loans.order(:created_at).first.created_at
        @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Time.zone.today.end_of_month
        @loans = current_cooperative.loans.for_archival_on(from_date: @from_date, to_date: @to_date)
        @loan_archive = LoansModule::LoansArchiveProcessing.new
      end

      def create
        @loan_archive = LoansModule::LoansArchiveProcessing.new(archive_params)
        if @loan_archive.archive!
          redirect_to new_loans_module_settings_archive_path, notice: "Loans archived successfully."
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def archive_params
        params.require(:loans_module_loans_archive_processing).permit(
          :cooperative_id,
          :employee_id,
          loan_ids: []
        )
      end
    end
  end
end
