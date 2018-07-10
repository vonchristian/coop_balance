class CalendarsController < ApplicationController
  def index
    month = params[:start_date] ? DateTime.parse(params[:start_date]).month : Date.today.month
    @members = Member.has_birth_month_on(month: month)
  end
  def show
    @date = params[:id] ? DateTime.parse(params[:id]).day : Date.today.day
    @members = Member.has_birth_day_on(birth_day: @date)
  end
end
