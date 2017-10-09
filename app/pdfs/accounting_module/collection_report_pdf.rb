module AccountingModule 
  class CollectionReportPdf < Prawn::Document 
    def initialize(entries, employee, from_date, to_date, view_context)
       super(margin: 40, page_size: "A4", page_layout: :portrait)
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
      elsif 
        entry.fund_transfer?
        entry.commercial_document.try(:first_and_last_name)
      end
    end

    def heading 
      image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 70, align: :center
      text "KIANGAN COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE"
      text "Poblacion, Kiangan, Ifugao", size: 12
      move_down 5
      text "COLLECTION REPORT"
      if @from_date.present?
        text "FROM: #{@from_date.strftime("%B %e, %Y %I:%M %p")}"
        text "To: #{@to_date.strftime("%B %e, %Y %I:%M %p")}" 
      end
      stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
      end
      if @employee.present?
        text "Employee: #{@employee.first_and_last_name}"
      end
    end 
    def account_details 
      table(accounts_data, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [180]) do
        cells.borders =[]
      end 
    end 
    def accounts_data
      [["Beginning Balance",  "#{price(AccountingModule::Account.find_by(name: "Cash on Hand").balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: (@from_date.beginning_of_day - 1.second), recorder_id: @employee.id))}"]] +
      [["Cash Disbursements", "#{price(AccountingModule::Asset.find_by(name: "Cash on Hand").credits_balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: @to_date.end_of_day, recorder_id: @employee.id))}"]] +
      [["Cash Receipts", "#{price(AccountingModule::Asset.find_by(name: "Cash on Hand").debits_balance(from_date: (@from_date.beginning_of_day - 1.second), to_date: @to_date.end_of_day, recorder_id: @employee.id))}"]] +
      [["Ending Balance", "#{price(AccountingModule::Asset.find_by(name: "Cash on Hand").balance(recorder_id: @employee.id))}" ]]
    end
    def entries_table
    if !@entries.any?
      move_down 10
      text "No entries data.", align: :center
    else
      move_down 10
      text "TRANSACTIONS:", size: 10, style: :bold
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      table(table_data, header: true, cell_style: { inline_format: true, size: 9, font: "Helvetica"}, column_widths: [80]) do
        cells.borders =[]
        row(0).font_style = :bold
        row(0).size = 8
        row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(3).align = :right
        row(-1).background_color = "F8FE06"
        row(-1).size = 9
      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "DESCRIPTION", "REFERENCE NUMBER", "AMOUNT", "MEMBER", "EMPLOYEE"]] +
    @table_data ||= @entries.entered_on(from_date: @from_date, to_date: @to_date, recorder_id: @employee.id).order(created_at: :asc).map { |e| [ e.entry_date.strftime("%b %e, %Y"), e.description, e.reference_number, price(e.debit_amounts.sum(&:amount)), display_commercial_document_for(e), e.recorder.try(:first_and_last_name)]} +
    [["TOTAL", "", "", "<b>#{price(@entries.total)}</b>", "", ""]]
  end
  end 
end 
