module StoreFrontModule
  class CheckoutForm
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    attr_accessor :customer_id

    validates :customer_id, presence: true

    def find_customer(customer_id)
      return User.find_by_id(customer_id) if User.find_by_id(customer_id).present?
      return Member.find_by_id(customer_id)
    end
  end
end
