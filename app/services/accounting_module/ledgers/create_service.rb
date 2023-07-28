# frozen_string_literal: true 

module AccountingModule 
  module Ledgers 
    class CreateService < ActiveInteraction::Base 
      anything :account_category 
      uuid :ledger_id, default: nil

      def execute 
        AccountingModule::Ledger.create!(
          account_type: account_category.normalized_type.downcase,
          name: account_category.title,
          code: account_category.code, 
          contra: account_category.contra,
          id: account_category.id,
          parent: ledger_id.present? ? AccountingModule::Ledger.find(ledger_id) : nil
        )
      end
    end 
  end 
end 
