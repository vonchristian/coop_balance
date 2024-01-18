module AccountingModule
  module Entries
    class UpdateProcessing
      include ActiveModel::Model
      attr_accessor :entry_date, :description, :reference_number, :entry_id

      validates :entry_date, :description, :reference_number, presence: true

      def process!
        return unless valid?

        ActiveRecord::Base.transaction do
          update_entry!
        end
      end

      private

      def update_entry!
        find_entry.update!(
          entry_date: entry_date,
          description: description,
          reference_number: reference_number
        )
        return if find_entry.voucher.nil?

        find_entry.voucher.update!(
          date: entry_date,
          description: description,
          reference_number: reference_number
        )
      end

      def find_entry
        AccountingModule::Entry.find(entry_id)
      end
    end
  end
end
