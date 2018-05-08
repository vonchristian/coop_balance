module SavingsAccounts
  class Query
    include ActiveModel::Model
    attr_accessor :limiting_num, :saving_product_id, :balance
  end
end
