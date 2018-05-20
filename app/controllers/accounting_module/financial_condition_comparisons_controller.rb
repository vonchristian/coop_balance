module AccountingModule
  class FinancialConditionComparisonsController < ApplicationController
    def new
      @comparison = AccountingModule::FinancialConditionComparison.new
    end
    def create
      @comparison = AccountingModule::FinancialConditionComparison.create(comparison_params)
      if @comparison.valid?
        @comparison.save
        redirect_to accounting_module_financial_condition_comparison_url(@comparison), notice: "Comparison created successfully"
      else
        render :new
      end
    end
    def show
      @comparison = AccountingModule::FinancialConditionComparison.find(params[:id])
      first_entry = AccountingModule::Entry.order('entry_date ASC').first
      @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
      @to_date = params[:entry_date] ? DateTime.parse(params[:entry_date]) : Time.zone.now
      @assets = AccountingModule::Asset.active.order(:code).all
      @liabilities = AccountingModule::Liability.active.order(:code).all
      @equity = AccountingModule::Equity.active.order(:code).all
      @employee = current_user
    end

    private
    def comparison_params
      params.require(:accounting_module_financial_condition_comparison).
      permit(:comparison_type, :first_date, :second_date)
    end
  end
end
