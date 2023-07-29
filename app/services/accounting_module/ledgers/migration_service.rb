# frozen_string_literal: true 

module AccountingModule 
  module Ledgers 
    class MigrationService < ActiveInteraction::Base 

      def execute 
        AccountingModule::Ledgers::L3MigrationService.run
        AccountingModule::Ledgers::L2MigrationService.run
        AccountingModule::Ledgers::L1MigrationService.run
        update_account_ledgers
        update_office_loan_product_aging_group_ledgers
        update_office_program_ledgers
        update_program_ledgers
        update_office_loan_product_ledgers 
        update_office_saving_product_ledgers
        update_office_share_capital_product_ledgers
        update_office_time_deposit_product_ledgers
        update_loan_aging_group_ledgers 
      end 

      def update_account_ledgers
        AccountingModule::Account.all.each do |account|
          account.update(ledger_id: account.level_one_account_category_id)
        end 
      end 

      def update_office_loan_product_aging_group_ledgers
        LoansModule::OfficeLoanProductAgingGroup.all.each do |group|
          group.update(ledger_id: group.level_one_account_category_id)
        end
      end

      def update_office_program_ledgers
        Offices::OfficeProgram.all.each do |program|
          program.update(ledger_id: program.level_one_account_category_id)
        end
      end 

      def update_program_ledgers 
        Cooperatives::Program.all.each do |program|
          program.update(ledger_id: program.level_one_account_category_id)
        end
      end 

      def update_office_loan_product_ledgers
        Offices::OfficeLoanProduct.all.each do |product|
          product.update(
            interest_revenue_ledger_id: product.interest_revenue_account_category_id,
            penalty_revenue_ledger_id: product.penalty_revenue_account_category_id 
          )
        end 
      end 

      def update_office_saving_product_ledgers
        Offices::OfficeSavingProduct.all.each do |product|
          product.update(
            liability_ledger_id: product.liability_account_category_id,
            interest_expense_ledger_id: product.interest_expense_account_category_id
          )
        end 
      end 

      def update_office_share_capital_product_ledgers
        Offices::OfficeShareCapitalProduct.all.each do |product|
          product.update(equity_ledger_id: product.equity_account_category_id)
        end 
      end 

      def update_office_time_deposit_product_ledgers
        Offices::OfficeTimeDepositProduct.all.each do |product|
          product.update(
            liability_ledger_id: product.liability_account_category_id,
            interest_expense_ledger_id: product.interest_expense_account_category_id,
            break_contract_revenue_ledger_id: product.break_contract_account_category_id
          )
        end 
      end 

      def update_loan_aging_group_ledgers
        LoansModule::LoanAgingGroup.all.each do |group|
          group.update(receivable_ledger_id: group.level_two_account_category_id)
        end
      end
    end 
  end 
end 
