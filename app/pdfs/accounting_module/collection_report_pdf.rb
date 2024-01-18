module AccountingModule
  class CollectionReportPdf < Prawn::Document
    attr_reader :view_context

    def initialize(entries, employee, from_date, to_date, view_context)
      super(margin: 30, page_size: 'A4', page_layout: :portrait)
      @entries = entries
      @employee = employee
      @from_date = from_date
      @to_date = to_date
      @view_context = view_context
      heading
      # account_details
      entries_table
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: 'P ')
    end

    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:full_name)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:full_name)
      else
        entry.commercial_document.try(:name)
      end
    end

    def heading
      bounding_box [310, 780], width: 60 do
        image Rails.root.join('app/assets/images/kccmc_logo.jpg').to_s, width: 70, height: 70
      end
      bounding_box [390, 770], width: 150 do
        text 'KCCMC', style: :bold, size: 22
        text 'Kalanguya Cultural Community', size: 10
        text 'Multipurpose Cooperative', size: 10
        move_down 10
      end
      bounding_box [0, 770], width: 400 do
        text 'TRANSACTIONS REPORT', style: :bold, size: 14
        move_down 5
        text "As of #{Time.zone.today.strftime('%B %e, %Y')}", size: 10
      end
      move_down 30
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end

    # def account_details
    #   table(accounts_data, cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,0,0,0]}, column_widths: [180]) do
    #     cells.borders =[]
    #     column(1).align = :right
    #   end
    # end
    # def accounts_data
    #   [["Start Date", "#{@from_date.strftime("%B %e, %Y")}"]] +
    #   [["End Date", "#{@to_date.strftime("%B %e, %Y")}"]] +
    #   [["Beginning Balance",  "#{price(@employee.cash_on_hand_account.balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: (@from_date.beginning_of_day - 1.second)))}"]] +
    #   [["Cash Disbursements", "#{price(@employee.cash_on_hand_account.credits_balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: @to_date.end_of_day))}"]] +
    #   [["Cash Receipts", "#{price(@employee.cash_on_hand_account.debits_balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: @to_date.end_of_day))}"]] +
    #   [["Ending Balance", "#{price(@employee.cash_on_hand_account.balance(recorder_id: @employee.id))}" ]]
    # end
    def entries_table
      if @entries.none?
        move_down 10
        text 'No entries data.', align: :center
      else

        table([['DATE', 'DESCRIPTION', 'REFERENCE NUMBER', 'MEMBER', 'ACCOUNT', 'AMOUNT']], cell_style: { inline_format: true, size: 6, font: 'Helvetica' }, column_widths: [50, 150, 50, 100, 100, 80]) do
          row(0).font_style = :bold
          row(0).background_color = 'DDDDDD'
        end
        @entries.each do |entry|
          table([[entry.entry_date.strftime('%B %e, %Y').to_s, entry.description.to_s, entry.reference_number.to_s, display_commercial_document_for(entry).try(:upcase).to_s]], cell_style: { size: 9, padding: [5, 5, 4, 0] }, column_widths: [50, 150, 50, 100, 100, 80]) do
            cells.borders = []
          end

          table([['', '', '', '', '', '<b>DEBIT</b>']] +
            entry.debit_amounts.map { |a| ['', '', '', '', '', a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: { inline_format: true, size: 8, padding: [0, 0, 0, 0] }) do
            cells.borders = []
            column(-1).align = :right
          end

          table([['', '', '', '', '', '<b>CREDIT</b>']] + entry.credit_amounts.map { |a| ['', '', '', '', '', a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: { inline_format: true, padding: [0, 0, 2, 0], size: 8 }) do
            cells.borders = []
            column(-1).align = :right
          end
          stroke do
            stroke_color 'CCCCCC'
            line_width 0.2
            stroke_horizontal_rule
          end
        end

      end
    end
  end
end
