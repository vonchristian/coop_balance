module PercentActive
  def percent_active(args={})
    (updated_at(args).count / self.count.to_f) * 100
  end
end
