module AccountingModule
  class CollectionReportPdf < Prawn::Document
    def initialize(entries, employee, from_date, to_date, view_context)
       super(margin: 10, page_size: "A4", page_layout: :portrait)
      @entries = entries
      @employee = employee
      @from_date = from_date
      @to_date = to_date
      @view_context = view_context
      heading
      account_details
      entries_table
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:full_name)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:full_name)
      elsif entry.fund_transfer?
        entry.commercial_document.try(:first_and_last_name)
      end
    end

    def heading
      bounding_box [0, 800], width: 100 do
        image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50, align: :center
      end

      bounding_box [0, 800], width: 600 do
        text "KIANGAN COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE", align: :center
        text "Poblacion, Kiangan, Ifugao", size: 12, align: :center
        move_down 10
        text "TRANSACTIONS REPORT", style: :bold, align: :center
      end
      move_down 5
      stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
      end
      if @employee.present?
        # image "#{@employee.avatar.path(:large)}", width: 50, height: 50
        move_down 5
        text "#{@employee.first_and_last_name.try(:upcase)}", size: 10, style: :bold
      end
    end
    def account_details
      table(accounts_data, cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,0,0,0]}, column_widths: [180]) do
        cells.borders =[]
        column(1).align = :right
      end
    end
    def accounts_data
      [["Start Date", "#{@from_date.strftime("%B %e, %Y")}"]] +
      [["End Date", "#{@to_date.strftime("%B %e, %Y")}"]] +
      [["Beginning Balance",  "#{price(@employee.cash_on_hand_account.balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: (@from_date.beginning_of_day - 1.second), recorder_id: @employee.id))}"]] +
      [["Cash Disbursements", "#{price(@employee.cash_on_hand_account.credits_balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: @to_date.end_of_day, recorder_id: @employee.id))}"]] +
      [["Cash Receipts", "#{price(@employee.cash_on_hand_account.debits_balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: @to_date.end_of_day, recorder_id: @employee.id) + @employee.fund_transfer_total)}"]] +
      [["Ending Balance", "#{price(@employee.cash_on_hand_account.balance(recorder_id: @employee.id) + @employee.fund_transfer_total)}" ]]
    end
    def entries_table
    if !@entries.any?
      move_down 10
      text "No entries data.", align: :center
    else
      move_down 10
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "TRANSACTION DETAILS:", size: 8, style: :bold
      table([["DATE", "DESCRIPTION", "REFERENCE NUMBER", "MEMBER", "EMPLOYEE", "ACCOUNT", "AMOUNT"]], cell_style: { inline_format: true, size: 6, font: "Helvetica"}, column_widths: [50, 130, 50, 100, 50, 100, 80]) do

        row(0).font_style= :bold
        row(0).background_color = 'DDDDDD'
      end
      @entries.each do |entry|
        table([["#{entry.entry_date.strftime("%B %e, %Y")}", "#{entry.description}", "#{entry.reference_number}",  "#{display_commercial_document_for(entry).try(:upcase)}", "#{entry.recorder.try(:first_and_last_name).try(:upcase)}"]], cell_style: { size: 9, padding: [5,5,4,0]}, column_widths: [50, 130, 50,  100, 50, 100, 80]) do
          cells.borders = []
        end

        table([["", "", "", "", "", "<b>DEBIT</b>"]]+
          entry.debit_amounts.map{|a| ["", "", "",  "", "", a.account.name,  price(a.amount)] }, column_widths: [50, 130, 50, 100, 50, 100, 80], cell_style: { inline_format: true, size: 8, padding: [0,0,0,0]}) do
          cells.borders = []
          column(-1).align = :right
        end

        table([["",  "", "","", "", "<b>CREDIT</b>"]] + entry.credit_amounts.map{|a| ["", "", "",  "", "",  a.account.name, price(a.amount)] }, column_widths: [50, 130, 50, 100, 50, 100, 80], cell_style: {inline_format: true, padding: [0,0,2,0], size: 8} ) do
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
