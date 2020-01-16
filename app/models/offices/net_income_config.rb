module Offices 
  class NetIncomeConfig < ApplicationRecord
    enum book_closing: [:annually, :semi_annually, :quarterly, :monthly]
   
    belongs_to :office,             class_name: 'Cooperatives::Office'
    belongs_to :net_income_account, class_name: 'AccountingModule::Account'
    
    validates :net_income_account_id, uniqueness: { scope: :office_id }
    def self.current 
      order(created_at: :desc).first 
    end 

    def date_setter
      "NetIncomeConfigs::DateSetters::#{book_closing.titleize.gsub(' ', "")}".constantize
    end 

    def beginning_date(date)
      date_setter.new(net_income_config: self, date: date).beginning_date
    end 

    def ending_date(date)
      date_setter.new(net_income_config: self, date: date).ending_date
    end 
  end
end 