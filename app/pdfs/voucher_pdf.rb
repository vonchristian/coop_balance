require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
class VoucherPdf < Prawn::Document 
  def initialize(voucher, view_context)
    super(margin: 30, page_size: "A4", page_layout: :portrait)
    @voucher = voucher 
    @view_context = view_context
    heading
    payee_details
    voucher_details
    barcode
  end

  private 
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading 
    bounding_box [0, 770], width: 100 do
        image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50, align: :center
      end 
      bounding_box [0, 770], width: 530 do
        text "KIANGAN COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE", align: :center
        text "Poblacion, Kiangan, Ifugao", size: 12, align: :center
        move_down 10
        text "CASH DISBURSEMENT VOUCHER", style: :bold, align: :center
        move_down 5
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
  end 
  def payee_details 
    text "VOUCHER DETAILS", style: :bold
    move_down 10
      if @voucher.for_employee?
        table([["", "Payee:", "#{@voucher.payee.try(:first_and_last_name).try(:upcase)}"]], cell_style: { inline_format: true, size: 12, font: "Helvetica"}, column_widths: [40, 100, 200]) do 
          cells.borders = []
        end
      elsif @voucher.for_purchases?
          table([["", "Payee:", "#{@voucher.payee.try(:name).try(:upcase)}"]], cell_style: { inline_format: true, size: 12, font: "Helvetica"}, column_widths: [40, 100, 200]) do 
          cells.borders = []
        end
      end
      table([["", "Description:", "#{@voucher.description}"]], cell_style: { inline_format: true, size: 12, font: "Helvetica"}, column_widths: [40, 100, 200]) do 
        cells.borders = []
      end
      table([["", "Date:", "#{@voucher.date.strftime("%B %e, %Y")}"]], cell_style: { inline_format: true, size: 12, font: "Helvetica"}, column_widths: [40, 100, 200]) do 
        cells.borders = []
      end
      stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
  end
  def voucher_details 
    text "ENTRY DETAILS", style: :bold
    if @voucher.entry.present?
      text "#{@voucher.entry.description}"
      text "DEBIT"
      @voucher.entry.debit_amounts.each do |amount|
        table([["#{amount.amount}", "#{amount.account.try(:name)}"]])
      end
      text "CREDIT"
      @voucher.entry.credit_amounts.each do |amount|
        table([["#{amount.amount}", "#{amount.account.try(:name)}"]])
      end
    end

    if @voucher.for_employee?
      table([["","ACCOUNT", "AMOUNT", "", ""]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [40, 200, 100, 100, 80]) do 
      cells.borders = []
      row(0).background_color = "DDDDDD"
      row(0).font_style = :bold
      column(2).align = :right

    end
      @voucher.voucher_amounts.each do |amount|
        table([["", "#{amount.account.try(:name)}", "#{price(amount.amount)}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,0,4,0]}, column_widths: [40, 200, 100]) do
          cells.borders = []
          column(2).align = :right
        end
      end
    elsif @voucher.for_purchases?
      table([["QTY","PRODUCT", "UNIT COST", "TOTAL COST"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [50, 250, 110, 110]) do 
      cells.borders = []
      row(0).background_color = "DDDDDD"
      row(0).font_style = :bold
    end
      @voucher.voucherable.stocks.each do |stock|
        table([[ "#{stock.quantity}","#{stock.name}", "#{stock.unit_cost}", "#{stock.total_cost}"]],  column_widths: [50, 250, 100, 110]) do 
          cells.borders = []
        end
      end
    end
     stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
    table([["", "TOTAL", "#{price(@voucher.voucher_amounts.sum(:amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,0,0,0]}, column_widths: [40, 200, 100, 100]) do 
      cells.borders = []
      column(2).align = :right

    end
  end
  def barcode 
    bounding_box([400, 670], width: 100) do
     barcode = Barby::Code128.new(@voucher.number)
      barcode.annotate_pdf(self, height: 40)
      move_down 3
      text "VOUCHER #: #{@voucher.number}", size: 8
    end
     # barcode = Barby::Code39.new(@voucher.number)
  end
end 