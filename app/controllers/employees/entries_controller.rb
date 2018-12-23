module Employees
  class EntriesController < ApplicationController
    def index
      @employee = current_cooperative.users.find(params[:employee_id])
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : DateTime.now.end_of_day
      if params[:entry_type].present?
        @entries = @employee.entries.order(reference_number: :desc).where(entry_type: params[:entry_type].to_sym)
        @paginated_entries = @entries.paginate(:page => params[:page], :per_page => 50)
      elsif params[:from_date].present? && params[:to_date].present?
        @from_date = DateTime.parse(params[:from_date])
        @to_date = DateTime.parse(params[:to_date])
        @entries = @employee.entries.order(reference_number: :desc).entered_on(from_date: @from_date, to_date: @to_date)
        @paginated_entries = @entries.paginate(:page => params[:page], :per_page => 50)
      elsif params[:search].present?
        @entries = @employee.entries.text_search(params[:search]).paginate(:page => params[:page], :per_page => 50)
      else
        @entries = @employee.entries.all.order(reference_number: :desc)
        @paginated_entries = @entries.paginate(:page => params[:page], :per_page => 50)
      end
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Employees::Reports::EntriesPdf.new(
            entries:      @entries,
            employee:     @employee,
            from_date:    @from_date,
            to_date:      @to_date,
            view_context: view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries Report.pdf"
        end
      end
    end
    def show
    end
  end
end
