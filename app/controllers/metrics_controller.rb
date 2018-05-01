class MetricsController < ApplicationController
  def index
    @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
    @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
    @served_members = Member.updated_at(from_date: @from_date, to_date: @to_date)
  end
end
