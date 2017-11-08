class ChargeAdjustmentForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :percent, :amount, :amortize_balance, :schedule_type, :date
  def save
  end
end
