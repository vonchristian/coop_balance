module AccountingModule
  module Entries
    class CashDisbursementsController < ApplicationController
      def index
        if params[:from_date].present? && params[:to_date].present?
          @from_date       = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.current.beginning_of_year
          @to_date         = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries_for_pdf = current_office.cash_accounts.credit_entries.entered_on(from_date: @from_date, to_date: @to_date)
          @ordered_entries = current_office.cash_accounts.credit_entries.order(reference_number: :desc).entered_on(from_date: @from_date, to_date: @to_date)
          @entries         = @ordered_entries.paginate(:page => params[:page], :per_page => 50)

        elsif params[:organization_id].present? && params[:search].present?
          @organization    = current_cooperative.organizations.find(params[:organization_id])
          @entries_for_pdf = @organization.member_entries.text_search(params[:search])
          if @entries_for_pdf.present?
            @from_date     = @organization.member_entries.not_cancelled.order(entry_date: :asc).first.entry_date
            @to_date       = @organization.member_entries.not_cancelled.order(entry_date: :desc).first.entry_date
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
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.current.beginning_of_year
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries_for_pdf = current_office.cash_accounts.credit_entries.entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc)
          @ordered_entries = current_office.cash_accounts.credit_entries.order(reference_number: :desc).where(cooperative_service_id: params[:cooperative_service_id])
          @entries = @ordered_entries.paginate(page: params[:page], per_page:  50)
        end
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              entries:      @entries_for_pdf,
              cooperative_service: @cooperative_service,
              employee:     current_user,
              cooperative:  current_cooperative,
              title: "Cash Disbursement Vouchers",
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
          end
        end
      end

      private
      def entries_for_pdf
        if params[:from_date].present? && params[:to_date].present?
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries = current_cooperative.cash_accounts.credit_entries.not_cancelled.order(reference_number: :asc).entered_on(from_date: @from_date, to_date: @to_date)
        elsif params[:search].present?
          @entries = current_cooperative.cash_accounts.credit_entries.not_cancelled.order(reference_number: :asc).text_search(params[:search])
        elsif params[:recorder_id].present?
          @recorder = current_cooperative.users.find(params[:recorder_id])
          @entries = @recorder.cash_accounts.credit_entries.not_cancelled.order(reference_number: :asc)
        # elsif params[:office_id].present?
        #   @office  = current_cooperative.offices.find(params[:office_id])
        #   @entries = current_cooperative.offices.find(params[:office_id]).entries.paginate(:page => params[:page], :per_page => 50)
        else
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries = current_cooperative.cash_accounts.credit_entries.not_cancelled.order(reference_number: :asc)
        end
      end
    end
  end
end
