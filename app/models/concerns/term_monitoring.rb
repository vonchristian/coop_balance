module TermMonitoring
  extend ActiveSupport::Concern
  included do
    has_many :terms, as: :termable, dependent: :destroy

    delegate :term, :matured?, :effectivity_date, :is_past_due?, :number_of_days_past_due, :remaining_term, :terms_elapsed, :maturity_date, to: :current_term, allow_nil: true

    def current_term
      terms.current
    end
  end
end
