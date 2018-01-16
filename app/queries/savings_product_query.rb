class SavingsProductQuery
  attr_reader :relation
  def initialize(relation = CoopServicesModule::SavingProduct.all)
    @relation = relation
  end
  def accounts_opened(options={})
    if options[:from_date] && options[:to_date]
      from_date = Chronic.parse(options[:from_date].to_date)
      to_date = Chronic.parse(options[:to_date].to_date)
      includes(:subscribers).where('subscribers.created_at' => (from_date.beginning_of_day)..(to_date.end_of_day))
    else
      subscribers
    end
  end
end
