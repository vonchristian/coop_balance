module Vouchers
  class Cancellation
    attr_reader :voucher

    def initialize(args={})
      @voucher = args.fetch(:voucher)
    end

    def cancel!
      if !voucher.disbursed? || !voucher.cancelled?
        voucher.update(cancelled_at: Date.current)
      end
    end
  end
end
