class Term < ApplicationRecord
  belongs_to :termable, polymorphic: true
  validates :term, presence: true, numericality: true

  def self.current
    order(effectivity_date: :asc).last
  end

  def matured?
    maturity_date < Time.zone.now
  end
end
