module AccountingModule
  module Reports
    module Cashbooks
      class CashDisbursementsController < ApplicationController
        def index
          @cooperative_service = params[:cooperative_service_id].present? ? current_cooperative.cooperative_services.find(params[:cooperative_service_id]) : nil
          if params[:from_date].present? && params[:to_date].present?
            @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
            @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
            @entries_for_pdf = current_cooperative.cash_accounts.credit_entries.where(cooperative_service_id: params[:cooperative_service_id]).entered_on(from_date: @from_date, to_date: @to_date)
            @ordered_entries = current_cooperative.cash_accounts.credit_entries.order(reference_number: :desc).where(cooperative_service_id: params[:cooperative_service_id]).entered_on(from_date: @from_date, to_date: @to_date)
            @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)

          elsif params[:organization_id].present? && params[:search].present?
            @organization = current_cooperative.organizations.find(params[:organization_id])
            @entries_for_pdf = @organization.member_entries.text_search(params[:search])
            if @entries_for_pdf.present?
              @from_date = @organization.member_entries.order(entry_date: :asc).first.entry_date
              @to_date = @organization.member_entries.order(entry_date: :desc).first.entry_date
            end
            @ordered_entries = @organization.member_entries.order(reference_number: :desc).text_search(params[:search])
            @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
            
          elsif params[:organization_id].blank? && params[:search].present?
            @entries_for_pdf = current_cooperative.entries.text_search(params[:search])
            if @entries_for_pdf.present?
              @from_date = @entries_for_pdf.order(entry_date: :asc).first.entry_date
              @to_date = @entries_for_pdf.order(entry_date: :desc).first.entry_date
            end
            @ordered_entries = current_cooperative.entries.order(reference_number: :desc).text_search(params[:search])
            @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)

          elsif params[:recorder_id].present?
            @recorder = current_cooperative.users.find(params[:recorder_id])
            @entries_for_pdf = @recorder.cash_accounts.credit_entries
            if @entries_for_pdf.present?
              @from_date = @entries_for_pdf.order(entry_date: :asc).first.entry_date
              @to_date = @entries_for_pdf.order(entry_date: :desc).first.entry_date
            end
            @ordered_entries = @recorder.cash_accounts.credit_entries.order(reference_number: :desc)
            @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
          
          else
            @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
            @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
            @entries_for_pdf = current_cooperative.cash_accounts.credit_entries.where(cooperative_service_id: params[:cooperative_service_id])
            @ordered_entries = current_cooperative.cash_accounts.credit_entries.where(cooperative_service_id: params[:cooperative_service_id]).order(reference_number: :desc)
            @entries = @ordered_entries.paginate(page: params[:page], per_page:  50)
          end
          respond_to do |format|
            format.html
            format.xlsx
            format.pdf do
              pdf = AccountingModule::CashBooks::CashDisbursementsPdf.new(
                from_date:    @from_date,
                to_date:      @to_date,
                entries:      @entries_for_pdf,
                cooperative_service: @cooperative_service,
                employee:     current_user,
                title: "Cash Disbursement Vouchers",
                view_context: view_context)
              send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
            end
          end
        end
      end
    end
  end
end
