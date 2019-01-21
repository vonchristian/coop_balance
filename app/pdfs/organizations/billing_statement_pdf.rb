module Organizations
  class BillingStatementPdf < Prawn::Document
    TABLE_WIDTHS = [110, 75, 75, 80, 80, 80, 80, 80, 80]
    def initialize(organization, loan_product, loans_pdf, cooperative, membership_type, date, view_context)
      super(margin: [20, 40, 20, 60], page_size: "A4", page_layout: :landscape)
      @organization = organization
      @loans = loans_pdf
      @cooperative = cooperative
      @membership_type = membership_type
      @date = date
      @loan_product = loan_product
      @view_context = view_context
      heading
      loan_details
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end

    def loan_product_title
      if @loan_product.name.downcase.gsub!(/[^0-9A-Za-z]/," ").include?("short term")
        "Short-Term Loan"
      else
        @loan_product.name
      end
    end

    def heading
      bounding_box([500, 550], width: 70, :height => 70) do
        image "#{Rails.root}/app/assets/images/#{@cooperative.abbreviated_name.downcase}_logo.jpg", width: 70, height: 70
      end
      bounding_box([580, 550], width: 180, :height => 70) do
        text "#{@cooperative.abbreviated_name}", style: :bold, size: 24
        text "#{@cooperative.name }", size: 10
      end
      bounding_box([0, 550], width: 400, :height => 70) do
        text "BILLING STATEMENT", style: :bold, size: 14
        move_down 2
        text "For the month of #{@date.to_date.strftime("%B %Y")}", size: 11
        if @membership_type == "associate_member"
          move_down 2
          text "#{loan_product_title} - Job-Orders", size: 14
        else
          move_down 2
          text "#{loan_product_title}", size: 14
        end
        move_down 2
        text "#{@organization.name}"
      end
      move_down 20
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end

    def loan_details
      if @loans.any?
        table(loans_table, 
          cell_style: { inline_format: true, size: 8, padding: [1,1,3,1]}, 
          column_widths: TABLE_WIDTHS) do
          cells.borders = []
          column(3).align = :right
          column(4).align = :right
          column(5).align = :right
          column(6).align = :right
          column(7).align = :right
          column(8).align = :right
          column(9).align = :right
        end
      else
        text "No loans data", size: 11
      end
    end

    def loans_table_header
      table([["BORROWER", "RELEASE DATE", "MATURITY", "LOAN AMOUNT", "LOAN BALANCE", "PRINCIPAL", "INTEREST", "ARREARS", "TOTAL DEDUCTION"]], 
        cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [4,1,4,1]}, 
        column_widths: TABLE_WIDTHS) do
          row(0).font_style= :bold
          row(0).background_color = 'DDDDDD'
          cells.borders = [:top, :bottom]
          column(3).align = :right
          column(4).align = :right
          column(5).align = :right
          column(6).align = :right
          column(7).align = :right
          column(8).align = :right
          column(9).align = :right
      end
    end

    def loans_table
      loans_table_header
      @loans_data ||= @loans.map{ |a| [
        a.borrower_name, 
        a.application_date.strftime("%b %e, %Y"), 
        a.maturity_date.strftime("%b %e, %Y"), 
        price(a.loan_amount), 
        price(a.principal_balance), 
        price(a.amortized_principal_for(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month)), 
        price(a.amortized_interest_for(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month)), 
        price(a.amortization_schedules.where(date: a.application_date..(@date.to_date - 1.month).end_of_month).sum(:principal)), 
        price(a.total_deductions(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month))] 
      }
    end
  end
end
