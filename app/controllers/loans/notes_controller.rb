module Loans
  class NotesController < ApplicationController
    respond_to :html, :json

    def index
      @loan = current_cooperative.loans.find(params[:loan_id])
      @notes = @loan.notes.paginate(page: params[:page], per_page: 25)
      @note = @loan.notes.build
    end

    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @note = @loan.notes.build
      respond_modal_with @note
    end

    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @note = @loan.notes.create(note_params)
      respond_modal_with @note, location: loan_notes_url(@loan), notice: "Note saved successfully."
    end

    private
    def note_params
      params.require(:note).
      permit(:date, :title, :content, :noter_id)
    end
  end
end
