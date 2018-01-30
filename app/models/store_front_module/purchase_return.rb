module StoreFrontModule
  class PurchaseReturn < ApplicationRecord
    belongs_to :supplier
  end
end
