class Tin < ApplicationRecord
  belongs_to :tinable, polymorphic: true
  def verified?
    TinVerification.verified?(self)
  end
end
