module AccountingModule
  module Entries
    class CancellationProcessing
      include ActiveModel::Model
      attr_accessor :cancelled_at, :cancelled_by_id, :cancellation_description, :entry_id
      validates :cancelled_at, :cancellation_description, :cancelled_by_id, presence: true
      def process!
        ActiveRecord::Base.transaction do
          cancel_entry!
        end
      end

      private
      def cancel_entry!
        find_entry.update_attributes!(
          cancelled: true,
          cancelled_at: cancelled_at,
          cancelled_by_id: cancelled_by_id,
          cancellation_description: cancellation_description
        )

        if find_entry.voucher.present?
          if loan_voucher?
            find_entry.voucher.voucher_amounts.last.commercial_document.destroy
          else
            find_entry.voucher.destroy
          end
        end
      end

      def loan_voucher?
        find_entry.voucher.voucher_amounts.last.commercial_document_type == "LoansModule::LoanApplication"
      end
      def find_entry
        AccountingModule::Entry.find(entry_id)
      end
    end
  end
end
