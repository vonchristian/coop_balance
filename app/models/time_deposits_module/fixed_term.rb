module TimeDepositsModule
  class FixedTerm < ApplicationRecord
    belongs_to :time_deposit, class_name: "MembershipsModule::TimeDeposit"
    before_save :set_default_date
    after_commit :set_maturity_date
    def self.current
      order(created_at: :asc).last
    end
    def matured?
      maturity_date < Time.zone.now
    end

    def number_of_months
      number_of_days / 30
    end
    private
    def set_default_date
      self.deposit_date ||= Time.zone.now
    end
    def set_maturity_date
      self.maturity_date = self.deposit_date + number_of_days.days
    end
  end
end
