module LoansModule
  module Loans
    class ArchiveProcessing
      include ActiveModel::Model
      attr_accessor :archived_at, :remarks

      def initialize(args={})
        @loan        = args.fetch(:loan)
        @archiver    = args.fetch(:archiver)
        @archived_at = args.fetch(:archived_at)
      end

      def archive!
        if loan.balance.zero?
          Archive.create!(
            record: loan,
            archiver: employee,
            archived_at: archived_at,
            remarks: remarks
          )
        end
      end
    end
  end
end
