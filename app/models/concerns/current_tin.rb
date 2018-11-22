module CurrentTin
  extend ActiveSupport::Concern
  included do
    has_many :tins, as: :tinable

    delegate :number, to: :current_tin, prefix: true, allow_nil: true
  end
  def current_tin
    tins.current
  end
end
