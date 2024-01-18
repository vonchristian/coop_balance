module Metricable
  def metric(options = {})
    first_date = options[:first_date] || Time.zone.today
    second_date   = options[:second_date] || Time.zone.today.last_month
    first_balance = total_balance(to_date: first_date)
    ((first_balance - total_balance(to_date: second_date)) / first_balance) * 100.0
  end

  def metric_color
    if metric.negative?
      'danger'
    elsif metric.positive?
      'success'
    end
  end

  def arrow_sign
    if metric.negative?
      'down'
    elsif metric.positive?
      'up'
    end
  end
end
