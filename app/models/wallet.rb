class Wallet < ApplicationRecord
  belongs_to :account_owner, polymorphic: true
  has_many :deactivations, as: :deactivatable
  belongs_to :account

  def active?
    recent_deactivation && recent_deactivation.active?
  end
  
  def current_deactivation
    deactivations.recent
  end
end
