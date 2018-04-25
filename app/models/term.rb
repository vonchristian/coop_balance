class Term < ApplicationRecord
  belongs_to :termable, polymorphic: true
  validates :term, presence: true, numericality: true
  delegate :disbursed?, to: :termable, allow_nil: true
  def self.current
    order(effectivity_date: :asc).last
  end

  def matured?
    maturity_date < Time.zone.now
  end

  def is_past_due?
    number_of_days_past_due > 1
  end

  def number_of_days_past_due
    ((Time.zone.now - maturity_date)/86400.0).to_i
  end

  def remaining_term
    term - terms_elapsed
  end

  def terms_elapsed
    if disbursed?
      (Time.zone.now.year * 12 + Time.zone.now.month) - (effectivity_date.year * 12 + effectivity_date.month)
    end
  end

  def number_of_months_past_due
    number_of_days_past_due / 30
  end
end
