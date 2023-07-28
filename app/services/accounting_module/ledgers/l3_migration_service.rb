# frozen_string_literal: true 

module AccountingModule 
  module Ledgers 
    class L3MigrationService < ActiveInteraction::Base 

      def execute 
        create_ledgers 
      end 

  
      def create_ledgers
        AccountingModule::LevelThreeAccountCategory.all.each do |account_category|
          AccountingModule::Ledgers::CreateService.run(account_category: account_category)
        end
      end 
    end 
  end 
end 
