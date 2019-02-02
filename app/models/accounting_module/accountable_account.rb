module AccountingModule
  class AccountableAccount < ApplicationRecord
    belongs_to :accountable, polymorphic: true
    belongs_to :account

    validates :account_id, uniqueness: { scope: :accountable_id }
  end
end
