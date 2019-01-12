module AccountingModule
  module Entries
    class UpdateProcessing
      include ActiveModel::Model
      attr_accessor :entry_date, :description, :reference_number, :entry_id
      validates :entry_date, :description, :reference_number, presence: true

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            update_entry!
          end
        end
      end

      private
      def update_entry!
        find_entry.update_attributes!(
          entry_date: entry_date,
          description: description,
          reference_number: reference_number
        )
        if !find_entry.voucher.nil?
          find_entry.voucher.update_attributes!(
            date: entry_date,
            description: description,
            reference_number: reference_number
          )
          if find_entry.voucher.voucher_amounts.last.commercial_document_type == "LoansModule::LoanApplication"
            find_entry.voucher.voucher_amounts.last.commercial_document.update_attributes(application_date: entry_date)
          end
        end
      end

      def find_entry
        AccountingModule::Entry.find(entry_id)
      end
    end
  end
end
