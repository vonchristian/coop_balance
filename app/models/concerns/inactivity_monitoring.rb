module InactivityMonitoring
  def number_of_days_inactive
    ((Time.zone.now - last_transaction_date)/86_400.0).round
  end
end
