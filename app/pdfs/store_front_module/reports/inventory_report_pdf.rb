module StoreFrontModule
  module Reports
    class InventoryReportPdf < Prawn::Document
      attr_reader :inventories, :date
      def initialize(args)
        @inventories = args[:inventories]
        @date        = args[:date]
        heading
        inventories_table 
      end
    end
  end
end
