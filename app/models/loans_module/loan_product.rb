module LoansModule
  class LoanProduct < ApplicationRecord
  	belongs_to :account, class_name: "AccountingModule::Account"
    has_many :loans
    has_many :loan_product_charges
    has_many :charges, through: :loan_product_charges

    delegate :name, to: :account, prefix: true

    validates :name, :interest_rate, :account_id, presence: true
    validates :name, uniqueness: true
    validates :interest_rate, numericality: true
    def self.accounts
      all.map{|a| a.account_name }
    end
  end
end
