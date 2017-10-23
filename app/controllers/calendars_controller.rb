class CalendarsController < ApplicationController 
  def index 
    month = params[:start_date] ? DateTime.parse(params[:start_date]).month : Date.today.month
    @members = Member.has_birthdays_on(month)
  end 
  def show 
    @date = params[:id] ? DateTime.parse(params[:id]).month : Date.today.month
    @members = Member.has_birthdays_on(@month)
  end
end 