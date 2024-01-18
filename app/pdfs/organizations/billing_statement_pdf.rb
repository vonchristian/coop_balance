module Organizations
  class BillingStatementPdf < Prawn::Document
    attr_reader :organization, :loans, :cooperative, :membership_type, :date, :loan_product, :employee, :view_context

    TABLE_WIDTHS = [150, 75, 75, 80, 80, 80, 80, 100].freeze
    def initialize(args)
      super(margin: [40, 40, 40, 80], page_size: 'A4', page_layout: :landscape)
      @organization =    args[:organization]
      @employee =        args[:employee]
      @loans =           args[:loans_pdf]
      @cooperative =     @employee.cooperative
      @membership_type = args[:membership_type]
      @date =            args[:date]
      @loan_product =    args[:loan_product]
      @view_context =    args[:view_context]
      heading
      loan_details
      signatory_details
    end

    private

    def price(number)
      @view_context.number_to_currency(number, unit: 'P ')
    end

    def loan_product_title
      if loan_product.name.downcase.gsub!(/[^0-9A-Za-z]/, ' ').include?('short term')
        'Short-Term Loan'
      else
        loan_product.name
      end
    end

    def heading
      bounding_box([450, 510], width: 65, height: 70) do
        image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 65, height: 65
      end
      bounding_box([530, 510], width: 200, height: 70) do
        move_down 5
        text cooperative.name.try(:upcase).to_s, style: :bold, size: 12
        text "#{cooperative.address} . #{cooperative.contact_number}", size: 8
      end
      bounding_box([0, 510], width: 400, height: 70) do
        text 'BILLING STATEMENT', style: :bold, size: 14
        move_down 2
        text "For the month of #{date.to_date.strftime('%B %Y')}", size: 11
        move_down 2
        if membership_type == 'associate_member'
          text "#{loan_product_title} - Job-Orders", size: 14
        else
          text loan_product_title.to_s, size: 14
        end
        move_down 2
        text organization.name.to_s
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end

    def loan_details
      if loans.any?
        table(loans_table,
              cell_style: { inline_format: true, size: 9, padding: [1, 2, 3, 2] },
              column_widths: TABLE_WIDTHS) do
          cells.borders = [:bottom]
          column(3).align = :right
          column(4).align = :right
          column(5).align = :right
          column(6).align = :right
          column(7).align = :right
          column(8).align = :right
        end
      else
        text 'No loans data', size: 11
      end
    end

    def loans_table_header
      table([['BORROWER', 'RELEASE DATE', 'MATURITY DATE', 'LOAN AMOUNT', 'LOAN BALANCE', 'PRINCIPAL', 'INTEREST', 'TOTAL AMORTIZATION']],
            cell_style: { inline_format: true, size: 8, font: 'Helvetica', padding: [4, 2, 4, 2] },
            column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
        cells.borders = %i[top bottom]
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        column(6).align = :right
        column(7).align = :right
        column(8).align = :right
      end
    end

    def loans_table
      loans_table_header
      loans_data || loans.map { |loan|
        [
          loan.borrower_name,
          loan.application_date.strftime('%D'),
          loan.maturity_date.strftime('%D'),
          price(loan.loan_amount),
          price(loan.principal_balance),
          price(amortized_principal(loan)),
          price(amortized_interest(loan)),
          price(total_amortization(loan))
        ]
      }
    end

    def signatory_details
      move_down 20
      table(signatory, cell_style: { inline_format: true, size: 9, font: 'Helvetica' },
                       column_widths: [120, 410]) do
        cells.borders = []
        row(3).font_style = :bold
      end
    end

    def signatory
      [['PREPARED BY', '']] +
        [['', '']] +
        [['', '']] +
        [[employee.first_middle_and_last_name.try(:upcase).to_s, '']] +
        [[employee.designation.try(:titleize).to_s, '']]
    end

    def amortized_principal(loan)
      loan.amortization_schedules.scheduled_for(from_date: date.to_date.beginning_of_month, to_date: date.to_date.end_of_month).total_principal
    end

    def amortized_interest(loan)
      loan.amortization_schedules.scheduled_for(from_date: date.to_date.beginning_of_month, to_date: date.to_date.end_of_month).sum(&:interest)
    end

    def total_amortization(loan)
      loan.amortization_schedules.total_amortization(from_date: date.to_date.beginning_of_month, to_date: date.to_date.end_of_month)
    end
  end
end
