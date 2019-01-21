class Tin < ApplicationRecord
  belongs_to :tinable, polymorphic: true
  validates :number, presence: true, uniqueness: { scope: :tinable_id }
  def self.with_no_tin(args={})
    where.not(id: args[:ids])
  end
  
  def self.current
    order(created_at: :desc).first || NullTin.new
  end

  def verified?
    TinVerifier.new(tin: self).verified?
  end
end
