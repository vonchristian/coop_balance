# frozen_string_literal: true 

module AccountingModule 
  class Ledger < ApplicationRecord
    has_ancestry

    enum account_type: {
      asset: 'asset',
      liability: 'liability',
      equity: 'equity',
      revenue: 'revenue',
      expense: 'expense'
    }
    
    def subsidiary_ledgers
      children
    end
  end
end
