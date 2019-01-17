module StoreFrontModule
  module Orders
    class CreditSalesOrderForm
      include ActiveModel::Model

      atrr_reader :employee, :cooperative
      attr_accessor :reference_number,

      def initialize(args)
        @employee = args.fetch(:employee)
        @cooperative = @employee.cooperative
      end
    end
  end
end
