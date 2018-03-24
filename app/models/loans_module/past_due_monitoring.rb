module LoansModule
  module PastDueMonitoring
    def is_past_due?
      maturity_date < Time.zone.now
    end

    def number_of_days_past_due
      ((Time.zone.now - maturity_date)/86400.0).to_i
    end
    def number_of_months_past_due
      number_of_days_past_due / 30
    end
  end
end
