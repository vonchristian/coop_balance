require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
class OrderPdf < Prawn::Document
  TABLE_WIDTHS = [30, 70,  40, 60]
  ORDER_DETAILS_WIDTHS = [20, 20, 15]
  def initialize(order, line_items, view_context)
    super(margin: 2, page_size: [204, 792], page_layout: :portrait)
    @order = order
    @line_items = line_items
    @view_context = view_context
    logo
    # business_details
    # heading
    # customer_details
    display_orders_table
    asterisks
      barcode

  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def logo
    move_down 10
    image "#{Rails.root}/app/assets/images/logo_grayscale.jpg", width: 50, height: 50, position: :center
    move_down 5
    text "HOJAP MULTIPURPOSE COOPERATIVE", align: :center, size: 8, style: :bold
    text "Haliap, Asipulo, Ifugao", size: 7, align: :center
    text "Email: hmpc@gmail.com", size: 7, align: :center
    text "Contact No: 999-999-999", size: 7, align: :center



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
      table(table_data, header: true, cell_style: { size: 6, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
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
    [["QTY", "PRODUCT", "COST", "TOTAL"]] +
    @table_data ||= @line_items.map { |e| [e.quantity, e.product_stock.try(:name), price(e.unit_cost), price(e.total_cost)]}
  end
  def asterisks
    move_down 10
    stroke_horizontal_rule
    move_down 10
    text "THIS SERVES AS YOUR OFFICIAL RECEIPT", size: 7, align: :center, style: :bold
    barcode = Barby::Code39.new(@order.official_receipt.number)
    barcode.annotate_pdf(self, height: 25, x: 5, y: cursor - 30)
    move_down 32
    text "OFFICIAL RECEIPT #: #{@order.official_receipt.number}", size: 7, align: :center


  end
  def barcode

  end
end
