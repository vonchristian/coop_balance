# frozen_string_literal: true 

module AccountingModule 
  module Ledgers 
    class L1MigrationService < ActiveInteraction::Base 

      def execute 
        create_ledgers 
      end 

  
      def create_ledgers
        AccountingModule::LevelOneAccountCategory.all.each do |account_category|
          AccountingModule::Ledgers::CreateService.run(account_category: account_category, ledger_id: account_category.level_two_account_category_id)
        end
      end 
    end 
  end 
end 
