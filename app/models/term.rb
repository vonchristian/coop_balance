class Term < ApplicationRecord
  NUMBER_OF_DAYS_IN_MONTH = 30
  belongs_to :termable, polymorphic: true
  validates :effectivity_date, presence: true
  validates :number_of_days, presence: true, numericality: { only_integer: true, greater_than: 0 }
  delegate :disbursed?, to: :termable, allow_nil: true

  def self.past_due
    where('maturity_date < ?', Date.today)
  end

  def number_of_months
    number_of_days / NUMBER_OF_DAYS_IN_MONTH
  end

  def self.current
    order(effectivity_date: :desc).first
  end

  def matured?
    maturity_date <= Time.zone.now
  end

  def is_past_due?
    matured?
  end
  def past_due?
    maturity_date < Time.zone.now
  end

  def grace_period_past_due?(grace_period = 0)
    maturity_date < Time.zone.now + grace_period.days
  end

  def number_of_days_past_due(date: Time.zone.now)
    num = ((date.to_datetime - maturity_date.to_datetime)/86400.0).to_i
    if num.positive?
      num
    else
      0
    end
  end

  def remaining_term
    ((maturity_date - Time.zone.now)/86400.0).to_i
  end

  def terms_elapsed
    (Time.zone.now.year * 12 + Time.zone.now.month) - (effectivity_date.year * 12 + effectivity_date.month)
  end

  def number_of_months_past_due
    number_of_days_past_due / NUMBER_OF_DAYS_IN_MONTH
  end

  def past_due_in_years
    number_of_months_past_due / 12
  end
end
