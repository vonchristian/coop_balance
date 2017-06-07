class ShareCapitalProduct < ApplicationRecord
  has_many :share_capital_product_shares
  has_many :subscribers, class_name: "ShareCapital"
  def cost_per_share
    share_capital_product_shares.last.cost_per_share
  end
  def subscribed
    subscribers.subscribed_shares
  end
end
