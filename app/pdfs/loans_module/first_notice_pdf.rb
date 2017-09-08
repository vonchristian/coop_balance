module LoansModule 
  class FirstNoticePdf < Prawn::Document 
    def initialize(loan, view_context)
      super(margin: 40, page_layout: :portrait)
      @loan = loan 
      @view_context = view_context
      heading
    end
    private 
    def heading
      text "First Notice"
    end
  end 
end 
