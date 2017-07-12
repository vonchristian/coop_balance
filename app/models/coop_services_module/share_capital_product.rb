module CoopServicesModule  
  class ShareCapitalProduct < ApplicationRecord
    has_many :share_capital_product_shares
    has_many :subscribers, class_name: "MembershipsModule::ShareCapital"


    def total_subscribed
      subscribers.subscribed_shares
    end

    def total_available_shares
      total_shares - total_subscribed
    end

    def total_shares
      share_capital_product_shares.total_shares
    end
  end
end