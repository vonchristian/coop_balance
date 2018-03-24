require 'prawn/qrcode'
module Members
  class PurchasesPdf < Prawn::Document
    def initialize(member, view_context)
      super(margin: 30, page_size: 'A4', page_layout: :portrait)
      @member = member
      @view_context = view_context
      purchases_details
    end

    private
    def purchases_details
      text "PURCHASES DETAILS"
      if @member.sales_orders.present?
        table(purchases_data) do
          cells.borders = []
        end
      else
        "NO DATA AVAILABLE"
      end
    end
    def purchases_data
      [["Date", "Total Cost"]]
      @purchases_data = @member.sales_orders.map{|a| [a.date.strftime("%B %e, %Y"), a.total_cost]}
    end
  end
end
