require 'will_paginate/array'
module AccountingModule
  class EntriesController < ApplicationController
    def index
      if params[:from_date].present? && params[:to_date].present?
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
        @entries = current_cooperative.entries.entered_on(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 50)
      elsif params[:search].present?
        @entries = current_cooperative.entries.text_search(params[:search]).paginate(:page => params[:page], :per_page => 50)
      # elsif params[:recorder].present?
      #   @recorder = current_cooperative.users.find(params[:recorder])
      #   @entries = @recorder.entries.paginate(:page => params[:page], :per_page => 50)
      # elsif params[:office_id].present?
      #   @office  = current_cooperative.offices.find(params[:office_id])
      #   @entries = current_cooperative.offices.find(params[:office_id]).entries.paginate(:page => params[:page], :per_page => 50)
      else
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
        @entries = current_cooperative.entries.order(entry_date: :desc).paginate(page: params[:page], per_page:  50)
      end
      respond_to do |format|
        format.html
        format.pdf do
          pdf = AccountingModule::EntriesPdf.new(
            from_date:    @from_date,
            to_date:      @to_date,
            entries:      @entries,
            employee:     current_user,
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
      @entry.update(edit_entry_params)
      if @entry.valid?
        @entry.save
        redirect_to accounting_module_entry_url(@entry), notice: "Entry updated successfully"
      else
        render :edit
      end
    end


    def show
      @entry = current_cooperative.entries.find(params[:id])
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
      permit(:recorder_id, :reference_number, :description, :entry_date)
    end
  end
end
