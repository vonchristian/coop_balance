require 'prawn/qrcode'
module Members
  class ReportPdf < Prawn::Document
    def initialize(member, view_context)
      super(margin: 30, page_size: 'A4', page_layout: :portrait)
      @member = member
      @view_context = view_context
      member_details
      subscription_details
      savings_account_details
    end

    private
    def member_details
      qrcode = RQRCode::QRCode.new("http://github.com/whomwah/rqrcode", :level=>:h, :size => 12, :dot => 2.8)
      render_qr_code(qrcode)
      move_down 10
      text "MEMBER DETAILS"
    end
    def subscription_details
      move_down 5
      stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
      end
      text "PROGRAM SUBSCRIPTION DETAILS"
    end
    def savings_account_details
      stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
      end
      text "SAVINGS"
      @member.savings.each do |savings_account|
        text "#{savings_account.saving_product_name}"
      end
    end
  end
end
