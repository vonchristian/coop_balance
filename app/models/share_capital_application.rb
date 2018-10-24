class ShareCapitalApplication < ApplicationRecord
  belongs_to :subscriber, polymorphic: true
  belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
  belongs_to :cooperative
  belongs_to :office, class_name: "CoopConfigurationsModule::Office"

  validates :subscriber_id, :subscriber_type, :share_capital_product_id, :office_id, presence: true
end
