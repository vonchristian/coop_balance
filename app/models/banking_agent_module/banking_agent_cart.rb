module BankingAgentModule 
  class BankingAgentCart < ApplicationRecord
    belongs_to :banking_agent
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", as: :temp_cart, dependent: :destroy 
  end
end 