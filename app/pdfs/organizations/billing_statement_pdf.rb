module Organizations
  class BillingStatementPdf < Prawn::Document
    def initialize(organization, view_context)
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @organization = organization
      @view_context = view_context
      heading
    end
    def heading
      text "Billing Statement"
    end
  end
end
