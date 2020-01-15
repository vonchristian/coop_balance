module Offices 
  class NetIncomeConfig < ApplicationRecord
    enum book_closing: [:annually, :semi_annually, :quarterly, :monthly]
   
    belongs_to :office,             class_name: 'Cooperatives::Office'
    belongs_to :net_income_account, class_name: 'AccountingModule::Account'
    
    def self.current 
      order(created_at: :desc).first 
    end 
  end
end 