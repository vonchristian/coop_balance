class Tin < ApplicationRecord
  belongs_to :tinable, polymorphic: true
  def self.with_no_tin(args={})
    where.not(id: args[:ids])
  end
  def self.current
    order(created_at: :desc).first || NullTin.new
  end
  def verified?
    TinVerification.verified?(self)
  end
end
