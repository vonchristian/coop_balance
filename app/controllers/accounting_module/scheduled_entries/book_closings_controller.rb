module AccountingModule
  module ScheduledEntries
    class BookClosingsController < ApplicationController
      def index; end

      def new
        @book_closing = AccountingModule::BookClosing.new
      end

      def create
        @book_closing = AccountingModule::BookClosing.new(book_closing_params)
        if @book_closing.valid?
          @book_closing.close_book!

          redirect_to accounting_module_scheduled_entries_book_closing_confirmation_url(id: @book_closing.find_voucher.id), notice: 'Voucher created successfully'
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def book_closing_params
        params.require(:accounting_module_book_closing)
              .permit(:date, :account_number, :employee_id)
      end
    end
  end
end