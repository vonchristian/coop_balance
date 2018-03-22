module Vouchers
  class VoucherAmount < ApplicationRecord
    enum amount_type: [:debit, :credit]
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :voucher
    belongs_to :commercial_document, polymorphic: true
    delegate :name, to: :account, prefix: true

    validates  :amount, :account_id,  :amount_type, presence: true
    validates :amount, numericality: true
    def self.total
      sum(:amount)
    end

    # def self.with_no_vouchers
    #   select{ |a| a.voucher.nil? }
    # end
  end
end
