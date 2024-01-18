module InactivityMonitoring
  def number_of_days_inactive
    ((Time.zone.now - default_last_transaction_date) / 86_400.0).round
  end

  def default_last_transaction_date
    last_transaction_date || created_at
  end
end
