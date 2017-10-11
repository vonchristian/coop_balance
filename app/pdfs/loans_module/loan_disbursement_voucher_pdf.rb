module LoansModule 
	class LoanDisbursementVoucherPdf < Prawn::Document 
		def initialize(loan, voucher, view_context)
      super(margin: 40, page_layout: :portrait)
      @loan = loan 
      @voucher = voucher 
      @view_context = view_context
      heading
      loan_details
      disbursement_table
    end

    private 
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading 
      image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50, position: :center
       move_down 20
    	text "LOAN DISBURSEMENT VOUCHER", align: :center
       # barcode = Barby::Code39.new(@voucher.number)
      stroke_horizontal_rule
      move_down 10
    end 
    def loan_details 
      text "#{@loan.loan_product_name}"
      text "#{@loan.loan_product.account_name}"

      text "#{price(@loan.loan_amount)}", style: :bold

    end
    def disbursement_table
      table(table_data, header: true, cell_style: { size: 10, font: "Helvetica"}) do
        cells.borders = []
        row(-1).font_style = :bold
        row(1).size = 8
        row(-1).background_color = 'DDDDDD'
        row(-3).background_color = 'D5456D'
        row(1).background_color = 'DDDDDD'


        row(-1).size = 14


        # row(0).background_color = 'DDDDDD'
        # column(0).align = :right
        column(3).align = :right
        column(4).align = :right
      end
    end

    def table_data
      move_down 5
      [["LOAN AMOUNT", "", "", "#{price(@loan.loan_amount)}"]] + 
      [["CHARGE NAME", "DEBIT ACCOUNT", "CREDIT ACCOUNT", "AMOUNT"]] +
      @table_data ||= @loan.loan_charges.map { |e| [e.name,  e.debit_account_name,  e.credit_account_name, price(e.charge_amount_with_adjustment) ]} +
      [["TOTAL CHARGES", "", "", "#{price(@loan.total_loan_charges)}"]] +
      [["", ""]] +
      [["Net Proceed", "", "", "#{price(@loan.net_proceed)}"]]

    end
  end 
end 
