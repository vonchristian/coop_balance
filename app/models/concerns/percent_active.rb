module PercentActive
  def percent_active(args = {})
    if updated_at(args).present?
      (updated_at(args).count / count.to_f) * 100
    else
      0
    end
  end
end
