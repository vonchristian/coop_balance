module Employees
  class BlotterPdf < Prawn::Document
    attr_reader :employee, :date, :view_context
    def initialize(args)
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @employee     = args[:employee]
      @accounts     = @employee.cash_accounts
      @date         = args[:date]
      @view_context = args[:view_context]
      heading
      summary
      amounts_received_table
      amounts_paid_table

    end

    private
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:full_name)
      elsif entry.commercial_document.try(:depositor).present?
        entry.commercial_document.try(:depositor).try(:full_name)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:name)
      elsif entry.commercial_document.try(:supplier).present?
        entry.commercial_document.try(:name)
      else
        entry.description
      end
    end

    def heading
      bounding_box [300, 780], width: 50 do
        image "#{Rails.root}/app/assets/images/kccmc.jpg", width: 50, height: 50
      end
      bounding_box [370, 780], width: 150 do
          text "KCCMC", style: :bold, size: 24
          text "Kalanguya Cultural Community Multipurpose Cooperative", size: 10
      end
      bounding_box [0, 780], width: 400 do
        text "#{employee.role.titleize}'s Blotter Report", style: :bold, size: 14
        move_down 3
        text "#{date.strftime("%B %e, %Y")}", size: 10
        move_down 3

        text "Employee: #{employee.name}", size: 10
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end
    def summary
      text "Summary", style: :bold, size: 10
      table([["", "TOTAL AMOUNTS PAID", "#{price(employee.cash_accounts.credits_balance)}"]], cell_style: {size: 9, column_widths: [20, 90, 100]}) do
        cells.borders = []
        column(2).align = :right
      end
      table([["", "TOTAL AMOUNTS RECEIVED", "#{price(employee.cash_accounts.debits_balance)}"]], cell_style: {size: 9, column_widths: [20, 90, 100]}) do
      cells.borders = []
        column(2).align = :right

      end
      move_down 5

      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 10
      end
    end
    def amounts_received_table
      text "AMOUNT RECEIVED", style: :bold, size: 10
      move_down 5
      table(amounts_received_data, cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [100, 125, 135,  50, 100]) do
        row(0).font_style= :bold
        row(0).background_color = 'DDDDDD'
        column(-1).align = :right
        row(-1).font_style = :bold
      end
    end
    def amounts_received_data
      [["Date", "Payee", "Description", "Amount"]] +
      @amounts_received_data ||= employee.cash_accounts.debit_entries.recorded_by(employee).map{|a| [a.entry_date.strftime("%B %e, %Y"), display_commercial_document_for(a), a.description, price(a.amounts.where(account: @employee.cash_on_hand_account).sum(&:amount)) ] } +
      [["", "", "", "TOTAL", ""]]
    end

    def amounts_paid_table
      move_down 15
      text "AMOUNTS PAID", style: :bold, size: 10
      move_down 5
      table(amounts_paid_data, cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [100, 125, 135,  50, 100])  do
        column(-1).align = :right
        row(0).font_style= :bold
        row(0).background_color = 'DDDDDD'
        row(-1).font_style = :bold
      end
    end
    def amounts_paid_data
      [["Date", "Payee", "Description", "Amount"]] +
      @amounts_paid_data ||= employee.cash_accounts.credit_entries.recorded_by(employee).map{|a| [a.entry_date.strftime("%B %e, %Y"), a.commercial_document.try(:name), a.description, price(a.amounts.where(account: @employee.cash_on_hand_account).sum(&:amount)) ] } +
      [["", "", "", "TOTAL", ""]]
    end
  end
end

