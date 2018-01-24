class ChargeAdjustmentForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :percent, :amount, :amortize_balance, :schedule_type, :date
  def save
    ActiveRecord::Base.transaction do
      save_charge_adjustment
      update_amortization_schedule
    end
  end

  private
  def save_charge_adjustment
  end
  def update_amortization_schedule

  end
end
