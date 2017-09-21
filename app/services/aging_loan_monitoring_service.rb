class AgingLoanMonitoringService 
  def number_of_days_due(loan, date)
    start_date = loan.disbursement.date 
    ((date - start_date)/86400).to_i
  end
  def number_of_months_due(loan, date)
    number = self.number_of_months_due(loan,date)
    number / 30
  end
end