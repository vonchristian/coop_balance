# frozen_string_literal: true 

module AccountingModule 
  module Ledgers 
    class MigrationService < ActiveInteraction::Base 

      def execute 
        AccountingModule::Ledgers::L3MigrationService.run
        AccountingModule::Ledgers::L2MigrationService.run
        AccountingModule::Ledgers::L1MigrationService.run
      end 
    end 
  end 
end 
