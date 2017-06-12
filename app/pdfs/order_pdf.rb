require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
class OrderPdf < Prawn::Document
  TABLE_WIDTHS = [30, 60,  40, 40]
  ORDER_DETAILS_WIDTHS = [20, 20, 15]
  def initialize(order, line_items, view_context)
    super(margin: 2, page_size: [180, 792], page_layout: :portrait)
    @order = order
    @line_items = line_items
    @view_context = view_context
    # business_details
    # barcode
    # heading
    # customer_details
    display_orders_table
    asterisks

  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def business_details
    table(business_details_data, cell_style: { size: 9, font: "Helvetica", inline_format: true, :padding => [0,0,0,0]}, column_widths: ORDER_DETAILS_WIDTHS) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
        row(0).font_style = :bold
        row(0).size = 12
        column(2).align = :right


    end
  end
  def business_details_data
      @business_details_data ||=  [[""]] +
                                  [["TIN", ""]] +
                                  [["Address"]] +
                                  [["Contact #"]] +
                                  [["Email #", "",  "No."]]


    end
    def barcode
      bounding_box [420, 690], width: 100 do
        barcode = Barby::Code39.new(@order.invoice_number.try(:number))
        barcode.annotate_pdf(self, height: 40)
      end
    end

  def heading
    move_down 2
    if @order.cash?
      text '<b>SALES INVOICE</b>', size: 14, align: :center, inline_format: true
    elsif @order.credit?o
      text '<b>CHARGE INVOICE</b>', size: 14, align: :center, inline_format: true

    end
    move_down 2
    stroke do
  stroke_color 'CCCCCC'
  line_width 0.2
  stroke_horizontal_rule
  move_down 15
end
  end
  def customer_details
    table(customer_details_data, cell_style: { :padding => [2,0,0,2], size: 10, font: "Helvetica", inline_format: true}, column_widths: ORDER_DETAILS_WIDTHS) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    # stroke_horizontal_rule

  end
  def customer_details_data
    @customer_details_data ||=  [["<b>Sold To:</b>      #{@order.member.try(:full_name)}", "", "<b>Date: </b> #{@order.date.strftime("%B %e, %Y")}"]] +
                                [["<b>Address</b>      #{@order.member.try(:address_details)}","", "<b>CRM #: </b>"]] +
                                [["<b>Mobile #</b>      #{@order.member.try(:mobile)}", "", "<b>Sold By:</b> #{@order.employee.try(:full_name)}"]]
  end
  def display_orders_table
    if @line_items.blank?
      move_down 10
      text "No orders data.", align: :center
    else
      move_down 10
      stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
      end
      table(table_data, header: true, cell_style: { size: 5, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        cells.borders = []
        # row(0).font_style = :bold
        # row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(3).align = :right
        column(4).align = :right
      end
    end
  end

  def table_data
    move_down 5
    [["QTY", "PRODUCT", "UNIT COST", "TOTAL COST"]] +
    @table_data ||= @line_items.map { |e| [e.quantity, e.product_stock.try(:name), price(e.unit_cost), price(e.total_cost)]}
  end
  def asterisks
    move_down 10
    text "*************************************************************************", size: 6
  end
end
