module TinMonitoring
  def with_no_tin
    where(id: self.ids - self.with_tin.ids)
  end

  def with_tin
    joins(:tins).where.not('tins.tinable_id' => nil)
  end
end
