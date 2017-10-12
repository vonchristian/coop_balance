require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
class VoucherPdf < Prawn::Document 
  def initialize(voucher, view_context)
    super(margin: 40, page_layout: :portrait)
    @voucher = voucher 
    @view_context = view_context
    heading
    voucher_details
  end

  private 
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading 
    image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50, position: :center
     move_down 20
    text "DISBURSEMENT VOUCHER", align: :center
    text "#{@voucher.number}"
     bounding_box([0, 10], width: 600) do
     barcode = Barby::Code128.new(@voucher.number)
      barcode.annotate_pdf(self, height: 20)
      move_down 3
    end
     # barcode = Barby::Code39.new(@voucher.number)
    stroke_horizontal_rule
    move_down 10
  end 
  def voucher_details 
    table([["AMOUNT", "ACCOUNT"]])
  end
end 