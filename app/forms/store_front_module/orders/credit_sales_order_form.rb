module StoreFrontModule
  module Orders
    class CreditSalesOrderForm
      include ActiveModel::Model

      attr_reader :employee, :cooperative
      attr_accessor :reference_number
    end
  end
end
