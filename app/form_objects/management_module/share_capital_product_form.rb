module ManagementModule
  class ShareCapitalProductForm
    include ActiveModel::Model
    attr_accessor :name, :share_count, :cost_per_share
    def register
      create_share_capital_product
      create_shares
    end

    private
    def create_share_capital_product
      CoopServicesModule::ShareCapitalProduct.find_or_create_by(name: name)
    end
    def find_share_capital_product
      CoopServicesModule::ShareCapitalProduct.find_by(name: name)
    end
    def create_shares
      find_share_capital_product.share_capital_product_shares.create(share_count: share_count, cost_per_share: cost_per_share)
    end
  end
end
