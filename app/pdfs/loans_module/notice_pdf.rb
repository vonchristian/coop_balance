module LoansModule 
  class NoticePdf < Prawn::Document 
    def initialize(notice, view_context)
      super(margin: 40, page_layout: :portrait)
      @notice = notice
      @view_context = view_context
      heading
    end
    private 
    def heading
      text "Payment Notice"
    end
  end 
end 
