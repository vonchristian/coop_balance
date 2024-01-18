class LoansModuleController < ApplicationController
  def index
    first_entry_date = current_cooperative.entries.order(entry_date: :desc).first.try(:entry_date) || (Time.zone.today - 999.years)
    @loan_products = current_cooperative.loan_products
    @from_date     = params[:from_date] ? DateTime.parse(params[:from_date]) : first_entry_date
    @to_date       = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today.end_of_year
  end
end
