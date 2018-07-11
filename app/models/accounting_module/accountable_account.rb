module AccountingModule
  class AccountableAccount < ApplicationRecord
    belongs_to :accountable, polymorphic: true
    belongs_to :account
  end
end
