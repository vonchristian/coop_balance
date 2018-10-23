class ShareCapitalApplication < ApplicationRecord
  belongs_to :subscriber, polymorphic: true
  belongs_to :share_capital_product
  belongs_to :cooperative
  belongs_to :office
end
