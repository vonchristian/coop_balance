module LoansModule
  class PredeductedInterest < ApplicationRecord
    has_one :entry, as: :commercial_document, class_name: "AccountingModule::Entry"
    belongs_to :loan
    belongs_to :credit_account, class_name: "AccountingModule::Account"
    belongs_to :debit_account, class_name: "AccountingModule::Account"

    validates :amount, :posting_date, presence: true
    validates :amount, numericality: true

    def self.post_interests # called from chron
      not_posted.each do |interest|
        interest.post!
      end
    end

    def self.not_posted
      select{ |a| !a.posted? }
    end

    def self.create_schedules_for(loan)
      loan.amortization_schedules.with_prededucted_interests.each do |schedule|
        create_schedule_for(schedule, loan)
      end
    end
    def self.create_schedule_for(schedule, loan)
      loan.prededucted_interests.create(posting_date: schedule.date, amount: schedule.interest, debit_account: schedule.debit_account, credit_account: schedule.credit_account)
    end
    def posted?
      entry.present?
    end
    def post!
      if can_be_posted?
        create_entry(payment_type: payment_type, description: 'Earned interest income', reference_number: "systems generated", entry_date: posting_date,
      debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: self],
      credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: self])
      end
    end
    def can_be_posted?
      !posted? && posting_date == Date.today
    end
  end
end
