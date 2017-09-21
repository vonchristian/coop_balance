module LoansModule 
  class AgingLoansPdf < Prawn::Document 
    def initialize(loans, start_num, end_num, view_context)
      super(margin: 40, page_layout: :portrait)
      @loans = loans
      @start_num = start_num
      @end_num = end_num 
      @view_context = view_context
      heading
      loans_table
    end
    private 
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading
      text "Aging Loans"
    end
    def loans_table
      table(table_data, header: true, cell_style: { size: 12, font: "Helvetica"}) do
        column(1).align = :right
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
      end
    end

    def table_data
      move_down 5
      [["Member", "Balance"]] + 
      @table_data ||= @loans.map { |e| [e.member.try(:full_name), price(e.balance)]}
    end
  end 
end 
