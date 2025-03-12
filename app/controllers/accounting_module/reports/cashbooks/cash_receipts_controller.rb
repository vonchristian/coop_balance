module AccountingModule
  module Reports
    module Cashbooks
      class CashReceiptsController < ApplicationController
        def index
          @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id]) if params[:cooperative_service_id].present?
          if params[:from_date].present? && params[:to_date].present?
            @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
            @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today.end_of_year
            @entries_for_pdf = current_cooperative.cash_accounts.debit_entries.where(cooperative_service_id: params[:cooperative_service_id]).entered_on(from_date: @from_date, to_date: @to_date)
            @ordered_entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc).where(cooperative_service_id: params[:cooperative_service_id]).entered_on(from_date: @from_date, to_date: @to_date)

          elsif params[:organization_id].present? && params[:search].present?
            @organization = current_cooperative.organizations.find(params[:organization_id])
            @entries_for_pdf = @organization.member_entries.text_search(params[:search])
            if @entries_for_pdf.present?
              @from_date = @organization.member_entries.order(entry_date: :asc).first.entry_date
              @to_date = @organization.member_entries.order(entry_date: :desc).first.entry_date
            end
            @ordered_entries = @organization.member_entries.order(reference_number: :desc).text_search(params[:search])

          elsif params[:organization_id].blank? && params[:search].present?
            @entries_for_pdf = current_cooperative.cash_accounts.debit_entries.text_search(params[:search])
            if @entries_for_pdf.present?
              @from_date = @entries_for_pdf.order(entry_date: :asc).first.entry_date
              @to_date = @entries_for_pdf.order(entry_date: :desc).first.entry_date
            end
            @ordered_entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc).text_search(params[:search])

          elsif params[:recorder_id].present?
            @recorder = current_cooperative.users.find(params[:recorder_id])
            @entries_for_pdf = @recorder.cash_accounts.debit_entries
            if @entries_for_pdf.present?
              @from_date = @entries_for_pdf.order(entry_date: :asc).first.entry_date
              @to_date = @entries_for_pdf.order(entry_date: :desc).first.entry_date
            end
            @ordered_entries = @recorder.cash_accounts.debit_entries.order(reference_number: :desc)

          else
            @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
            @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today.end_of_year
            @entries_for_pdf = current_cooperative.cash_accounts.debit_entries.where(cooperative_service_id: params[:cooperative_service_id])
            @ordered_entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc).where(cooperative_service_id: params[:cooperative_service_id])
          end
          @entries = @ordered_entries.paginate(page: params[:page], per_page: 50)
          respond_to do |format|
            format.html
            format.xlsx
            format.pdf do
              pdf = AccountingModule::CashBooks::CashReceiptsPdf.new(
                from_date: @from_date,
                to_date: @to_date,
                entries: @entries_for_pdf,
                cooperative_service: @cooperative_service,
                title: "Cash Receipts Journal",
                employee: current_user,
                view_context: view_context
              )
              send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Entries report.pdf"
            end
          end
        end
      end
    end
  end
end
