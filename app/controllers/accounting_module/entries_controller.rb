require 'will_paginate/array'
module AccountingModule
  class EntriesController < ApplicationController
    def index
      if params[:entry_type].present?
        @entries = AccountingModule::Entry.where(entry_type: params[:entry_type].to_sym).paginate(:page => params[:page], :per_page => 50)
      elsif params[:from_date].present? && params[:to_date].present?
        @from_date = DateTime.parse(params[:from_date])
        @to_date = DateTime.parse(params[:to_date])
        @entries = AccountingModule::Entry.entered_on(from_date: @from_date, to_date: @to_date)
      elsif params[:from_date].present? && params[:to_date].present?
        @from_date = DateTime.parse(params[:from_date])
        @to_date = DateTime.parse(params[:to_date])
        entries = AccountingModule::Entry.entered_on(from_date: @from_date, to_date: @to_date)
        @entries = entries.paginate(:page => params[:page])
      elsif params[:search].present?
        @entries = AccountingModule::Entry.text_search(params[:search]).paginate(:page => params[:page], :per_page => 50)
      elsif params[:recorder].present?
        @entries = User.find(id: params[:recorder_id]).entries
      elsif params[:branch_office_id].present?
        @entries = CoopConfigurationsModule::BranchOffice.find(params[:branch_office_id]).entries
      else
        @entries = AccountingModule::Entry.all.order(entry_date: :desc).paginate(:page => params[:page], :per_page => 50)
      end
    end
    def new
      @entry = AccountingModule::EntryForm.new
    end
    def create
      @entry = AccountingModule::EntryForm.new(entry_params)
      if @entry.valid?
        @entry.save
        redirect_to accounting_module_entries_url, notice: "Entry saved successfully"
      else
        render :new
      end
    end
    def edit
      @entry = AccountingModule::Entry.find(params[:id])
    end
    def update
      @entry = AccountingModule::Entry.find(params[:id])
      @entry.update(edit_entry_params)
      if @entry.valid?
        @entry.save
        redirect_to accounting_module_entry_url(@entry), notice: "Entry updated successfully"
      else
        render :edit
      end
    end


    def show
      @entry = AccountingModule::Entry.find(params[:id])
    end
    def destroy
      @entry = AccountingModule::Entry.find(params[:id])
      @entry.destroy
      redirect_to accounting_module_entries_url, notice: "Entry destroyed successfully."
    end

    private
    def entry_params
      params.require(:accounting_module_entry_form).permit(:recorder_id, :amount, :debit_account_id, :credit_account_id, :entry_date, :description, :reference_number, :entry_type)
    end
    def edit_entry_params
      params.require(:accounting_module_entry).
      permit(:recorder_id, :reference_number, :description)
    end
  end
end
