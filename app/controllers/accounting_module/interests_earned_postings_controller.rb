module AccountingModule
  class InterestsEarnedPostingsController < ApplicationController
    def create
      date = DateTime.parse(params[:date])
      employee = current_user
      InterestPosting.new.post_interests_earned(date, employee)
      redirect_to accounting_module_schedules_path, notice: 'Interests posted successfully.'
    end
  end
end
