module Metricable
  def metric(options={})
      first_date = options[:first_date] || Date.today
      second_date = options[:second_date] || Date.today.last_month
      first_balance = total_balances(to_date: first_date)
      ((first_balance - total_balances(to_date: second_date))/ first_balance) * 100.0
    end

    def metric_color
      if metric.negative?
        "danger"
      elsif metric.positive?
        "success"
      end
    end
    def metric_chevron
      if metric.negative?
        "down"
      elsif metric.positive?
        "up"
      end
    end
end