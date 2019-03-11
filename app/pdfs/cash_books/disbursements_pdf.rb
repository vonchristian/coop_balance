module CashBooks
  class DisbursementsPdf < Prawn::Document
    attr_reader :entries, :employee, :from_date, :to_date, :view_context, :cooperative, :accounts, :title, :cooperative_service
    def initialize(args)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @entries      = args[:entries]
      @employee     = args[:employee]
      @cooperative_service = args[:cooperative_service]
      @cooperative  = @employee.cooperative
      @accounts     = @employee.cash_accounts
      @from_date    = args[:from_date]
      @to_date      = args[:to_date]
      @title        = args[:title]
      @view_context = args[:view_context]
      heading
      entries_table
      sub_totals_table
    end

    private
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def display_commercial_document_for(entry)
      entry.commercial_document.try(:abbreviated_name) || entry.commercial_document.name
    end

    def heading
      bounding_box [300, 770], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
      end
      bounding_box [360, 770], width: 200 do
          text "#{cooperative.abbreviated_name }", style: :bold, size: 20
          text "#{cooperative.name.try(:upcase)}", size: 8
          text "#{cooperative.address}", size: 8
      end
      bounding_box [0, 770], width: 400 do
        text "#{title.upcase}", style: :bold, size: 14
        move_down 5
        table([["Employee:", "#{employee.first_middle_and_last_name}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        table([[{content: "#{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", colspan: 2}]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        if !cooperative_service.nil?
          table([[{content: cooperative_service.title, colspan: 2}]], 
            cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
            column_widths: [50, 150]) do
            cells.borders = []
            column(1).font_style = :bold
          end
        end
      end
      move_down 10
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 5
      end
    end

    def entries_table_header
      table([["DATE", {content: 'PARTICULARS', colspan: 2}, "REF. NO.", "DEBIT", "CREDIT"]], 
        cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [4,2,4,2]}, 
        column_widths: [40, 140, 165, 50, 70, 70]) do
        row(0).font_style= :bold
        row(0).background_color = 'DDDDDD'
        column(4).align = :right
        column(5).align = :right
        column(2).align = :center
        column(1).align = :center
      end
    end

    def entries_table
      if !@entries.any?
        move_down 10
        text "No entries data.", align: :center
      else
        entries_table_header

        entries_data ||= entries.sort_by{|e| e.reference_number.to_i}.map do |entry|
          [
            entry.entry_date.strftime("%D"), 
            display_commercial_document_for(entry).try(:upcase),
            entry.description, 
            "##{entry.reference_number}",
            entry.debit_amounts.where(account: employee.cash_accounts).sum{|a| a.amount}.zero? ? "-" : price(entry.debit_amounts.where(account: employee.cash_accounts).sum{|a| a.amount}), 
            entry.credit_amounts.where(account: employee.cash_accounts).sum{|a| a.amount}.zero? ? "-" : price(entry.credit_amounts.where(account: employee.cash_accounts).sum{|a| a.amount})
          ] 
        end
        table(entries_data, 
          cell_style: { inline_format: true, size: 8, padding: [1,5,3,2]}, 
          column_widths: [40, 140, 165, 50, 70, 70]) do
          column(4).align = :right
          column(5).align = :right
        end
        grand_total_table
      end
    end

    def grand_total_table
      grand_total_data = [[{content: "Grand Total: ", colspan: 4}, "", price(grand_total) ]]
      table(grand_total_data, 
        cell_style: { inline_format: true, size: 8, padding: [1,5,3,2]}, 
        column_widths: [40, 140, 165, 50, 70, 70]) do
        row(0).font_style= :bold
        column(4).align = :right
        column(5).align = :right
      end
    end

    def sub_totals_table
      if grouped_similar_reference_numbers.any?
        move_down 8
        text "List of similar reference numbers with their total amounts. (#{grouped_similar_reference_numbers.count})", size: 9
        move_down 4
        sub_total_data ||= grouped_similar_reference_numbers.sort_by{|e| e.to_i}.map do |reference_number|
          ["", "", "No. of Entries: #{entries.where(reference_number: reference_number).count}", "##{reference_number}", "", "#{price(credits_sub_total(reference_number))}"]
        end
        table(sub_total_data, 
          cell_style: { inline_format: true, size: 8, padding: [1,5,3,2]}, 
          column_widths: [40, 140, 165, 50, 70, 70]) do
          column(4).align = :right
          column(5).align = :right
        end
      end
    end

    def grand_total
      AccountingModule::CreditAmount.where(entry_id: entries.pluck(:id)).where(account: employee.cash_accounts).sum{|a| a.amount}
    end

    def grouped_similar_reference_numbers
      entries.where(reference_number: entries.select(:reference_number).group(:reference_number).having('count(*) > 1')).order(:reference_number).pluck(:reference_number).uniq
    end

    def debits_sub_total(reference_number)
      ids = entries.where(reference_number: reference_number).pluck(:id)
      AccountingModule::DebitAmount.where(entry_id: ids).where(account: employee.cash_accounts).sum{|a| a.amount}
    end

    def credits_sub_total(reference_number)
      ids = entries.where(reference_number: reference_number).pluck(:id)
      AccountingModule::CreditAmount.where(entry_id: ids).where(account: employee.cash_accounts).sum{|a| a.amount}
    end
  end
end

