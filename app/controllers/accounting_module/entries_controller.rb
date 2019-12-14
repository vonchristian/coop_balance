require 'will_paginate/array'
module AccountingModule
  class EntriesController < ApplicationController


    def index
      if params[:from_date].present? && params[:to_date].present?
        @from_date = params[:from_date] ? Date.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today.end_of_year
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id]) if params[:cooperative_service_id].present?
        @entries_for_pdf = current_cooperative.entries.where(cooperative_service_id: params[:cooperative_service_id]).entered_on(from_date: @from_date, to_date: @to_date)
        @ordered_entries = current_cooperative.entries.order(reference_number: :desc).where(cooperative_service_id: params[:cooperative_service_id]).entered_on(from_date: @from_date, to_date: @to_date)
        @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
        @office = current_user.office


      elsif params[:organization_id].present? && params[:search].present?
        @organization = current_cooperative.organizations.find(params[:organization_id])
        @entries_for_pdf = @organization.member_entries.text_search(params[:search])
        if @entries_for_pdf.present?
          @from_date = @organization.member_entries.not_cancelled.order(entry_date: :asc).first.entry_date
          @to_date = @organization.member_entries.not_cancelled.order(entry_date: :desc).first.entry_date
        end
        @ordered_entries = @organization.member_entries.order(reference_number: :desc).text_search(params[:search])
        @office = current_user.office

        @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)

      elsif params[:organization_id].blank? && params[:search].present?
        @entries_for_pdf = current_cooperative.entries.text_search(params[:search])
        if @entries_for_pdf.present?
          @from_date = @entries_for_pdf.order(entry_date: :asc).first.entry_date
          @to_date = @entries_for_pdf.order(entry_date: :desc).first.entry_date
        end
        @ordered_entries = current_cooperative.entries.order(reference_number: :desc).text_search(params[:search])
        @office = current_user.office

        @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)

      elsif params[:recorder_id].present?
        @recorder = current_cooperative.users.find(params[:recorder_id])
        @ordered_entries = @recorder.entries
        @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
        @office = current_user.office


      elsif params[:organization_id].present? && params[:search].blank?
        @organization = current_cooperative.organizations.find(params[:organization_id])
        @entries_for_pdf = @organization.member_entries
        if @entries_for_pdf.present?
          @from_date = @entries_for_pdf.order(entry_date: :asc).first.entry_date
          @to_date = @entries_for_pdf.order(entry_date: :desc).first.entry_date
        end
        @ordered_entries = @organization.member_entries.order(reference_number: :desc)
        @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
        @office = current_user.office


      else
        @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.current
        @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today.end_of_year
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id]) if params[:cooperative_service_id].present?
        @entries_for_pdf = current_cooperative.entries.where(cooperative_service_id: params[:cooperative_service_id])
        @ordered_entries = current_cooperative.entries.order(reference_number: :desc).where(cooperative_service_id: params[:cooperative_service_id])
        @entries = @ordered_entries.paginate(page: params[:page], per_page:  50)
        @office = current_user.office
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
            organization: @organization,
            employee:     current_user,
            cooperative:  current_cooperative,
            title:        "Journal Entries",
            view_context: view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
        end
      end
    end

    def new
      @line_item = Vouchers::VoucherAmountProcessing.new
    end

    def create
      @line_item = Vouchers::VoucherAmountProcessing.new(entry_params)
      if @line_item.valid?
        @line_item.save
        redirect_to new_accounting_module_entry_line_item_url, notice: "Entry saved successfully"
      else
        render :new
      end
    end

    def edit
      @entry = current_cooperative.entries.find(params[:id])
    end

    def update
      @entry = current_cooperative.entries.find(params[:id])
      @entry_form = AccountingModule::Entries::UpdateProcessing.new(edit_entry_params)
      if @entry_form.valid?
        @entry_form.process!
        redirect_to accounting_module_entry_url(@entry), notice: "Entry updated successfully"
      else
        render :edit
      end
    end

    def show
      @entry = current_cooperative.entries.includes(amounts: [:account]).find(params[:id])
    end

    def destroy
      @entry = current_cooperative.entries.find(params[:id])
      @entry.destroy
      redirect_to accounting_module_entries_url, notice: "Entry destroyed successfully."
    end

    private
    def entry_params
      params.require(:accounting_module_entry_form).permit(:recorder_id, :amount, :debit_account_id, :credit_account_id, :entry_date, :description, :reference_number, :entry_type)
    end

    def edit_entry_params
      params.require(:accounting_module_entry).
      permit(:recorder_id, :reference_number, :description, :entry_date, :entry_id)
    end

    def entries_for_pdf
      if params[:from_date].present? && params[:to_date].present?
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
        @entries = current_cooperative.entries.not_cancelled.order(reference_number: :asc).entered_on(from_date: @from_date, to_date: @to_date)
      elsif params[:search].present?
        @entries = current_cooperative.entries.where(cancelled: false).order(reference_number: :asc).text_search(params[:search])
        @from_date = @entries.order(entry_date: :asc).first.entry_date
        @to_date = @entries.order(entry_date: :desc).first.entry_date
      elsif params[:recorder_id].present?
        @recorder = current_cooperative.users.find(params[:recorder_id])
        @entries = @recorder.entries.where(cancelled: false).order(reference_number: :asc)
      # elsif params[:office_id].present?
      #   @office  = current_cooperative.offices.find(params[:office_id])
      #   @entries = current_cooperative.offices.find(params[:office_id]).entries.paginate(:page => params[:page], :per_page => 50)
      else
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
        @entries = current_cooperative.entries.where(cancelled: false).order(reference_number: :asc)
      end
    end

  end
end
