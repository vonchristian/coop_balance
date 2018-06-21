class MetricsController < ApplicationController
  def index
    @saving_metric = CoopServicesModule::SavingProduct.metric
    @share_capital_metric = CoopServicesModule::ShareCapitalProduct.metric
    @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
    @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
    @members = Member.updated_at(from_date: @from_date, to_date: @to_date)
    @revenues = AccountingModule::Revenue.updated_at(from_date: @from_date, to_date: @to_date)
    @expenses = AccountingModule::Expense.updated_at(from_date: @from_date, to_date: @to_date)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = MetricsPdf.new(@members, @revenues, @expenses, @from_date, @to_date, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Metrics.pdf"
      end
    end
  end
end
