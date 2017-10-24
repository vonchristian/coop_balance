require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

class ShareCapitalPdf < Prawn::Document
  def initialize(share_capital, employee, view_context)
    super(margin: 30, page_size: "A4", page_layout: :portrait)
    @share_capital = share_capital
    @employee = employee
    @view_context = view_context
    heading

  end
  private
  def heading 
    bounding_box [0, 780], width: 100 do
      image "#{@employee.cooperative_logo.path(:large)}", width: 50, height: 50, align: :center
    end 
    bounding_box [0, 780], width: 530 do
      text "#{@employee.cooperative_name.upcase}", align: :center, style: :bold
      text "#{@employee.cooperative_address} | #{@employee.cooperative_contact_number}", size: 12, align: :center
    

      move_down 10

      text "SHARE CAPITAL REPORT", style: :bold, align: :center
      text "#{@share_capital.account_number}", style: :bold, align: :center
       barcode = Barby::Code39.new(@share_capital.account_number)
    barcode.annotate_pdf(self, height: 35, x: 5, y: cursor - 30)
      move_down 5
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end
  end 
end