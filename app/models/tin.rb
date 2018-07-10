class Tin < ApplicationRecord
  belongs_to :tinable, polymorphic: true
  def self.current
    order(created_at: :desc).first || NullTin.new
  end
  def verified?
    TinVerification.verified?(self)
  end
end
