module Loans
  class NotesController < ApplicationController
    def index
      @loan = LoansModule::Loan.find(params[:loan_id])
      @notes = @loan.notes.paginate(page: params[:page], per_page: 25)
    end
    def new
      @loan = LoansModule::Loan.find(params[:loan_id])
      @note = @loan.notes.build
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @note = @loan.notes.create(note_params)
      if @note.valid?
        @note.save
        redirect_to loan_notes_url(@loan), notice: "Note saved successfully."
      else
        render :new
      end
    end

    private
    def note_params
      params.require(:note).
      permit(:date, :title, :content)
    end
  end
end
