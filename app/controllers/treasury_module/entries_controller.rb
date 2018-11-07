module TreasuryModule
  class EntriesController < ApplicationController
    def index
      @employees = current_cooperative.users
      if params[:entry_type].present?
        @entries = current_cooperative.entries.where(entry_type: params[:entry_type].to_sym).paginate(:page => params[:page], :per_page => 50)
      elsif params[:from_date].present? && params[:to_date].present?
        @from_date = DateTime.parse(params[:from_date])
        @to_date = DateTime.parse(params[:to_date])
        @entries = current_cooperative.entries.entered_on(from_date: @from_date, to_date: @to_date)
      elsif params[:from_date].present? && params[:to_date].present?
        @from_date = DateTime.parse(params[:from_date])
        @to_date = DateTime.parse(params[:to_date])
        entries = current_cooperative.entries.entered_on(from_date: @from_date, to_date: @to_date)
        @entries = entries.paginate(:page => params[:page])
      elsif params[:search].present?
        @entries = current_cooperative.entries.text_search(params[:search]).paginate(:page => params[:page], :per_page => 50)
      elsif params[:recorder_id].present?
        @entries = current_cooperative.users.find_by(id: params[:recorder_id]).entries
      else
        @entries = current_cooperative.entries.paginate(:page => params[:page], :per_page => 50)
      end
    end
  end
end
