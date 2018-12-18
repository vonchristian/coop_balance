module Employees
  module Reports
    class EntriesPdf < Prawn::Document
      attr_reader :entries, :employee, :from_date, :to_date, :view_context, :cooperative

      def initialize(args)
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @entries      = args[:entries]
        @employee     = args[:employee]
        @cooperative = @employee.cooperative
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @view_context = args[:view_context]
        heading
        entries_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
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
        bounding_box [370, 770], width: 210 do
          text "#{cooperative.abbreviated_name}", style: :bold, size: 22
          text "#{cooperative.name}", size: 10
          move_down 10
        end

        bounding_box [0, 770], width: 400 do
          text "TRANSACTIONS REPORT", style: :bold, size: 14
          move_down 5
          table([["Employee:", "#{employee.first_and_last_name}"]], 
            cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
            column_widths: [50, 150]) do
            cells.borders = []
          end
          table([["From:", "#{from_date.strftime("%B %e, %Y")}"]], 
            cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
            column_widths: [50, 150]) do
            cells.borders = []
          end
          table([["To:", "#{to_date.strftime("%B %e, %Y")}"]], 
            cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
            column_widths: [50, 150]) do
            cells.borders = []
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

      def entries_table
        if !entries.any?
          move_down 10
          text "No entries data.", align: :center
        else

          table([["DATE", "DESCRIPTION", "REF. NO.", "MEMBER/PAYEE",  "", "", ""]], 
            cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [4,1,4,1]}, 
            column_widths: [40, 135, 50, 70, 100, 70, 70]) do
              row(0).font_style= :bold
              row(0).background_color = 'DDDDDD'
              cells.borders = [:top]
              column(5).align = :right
              column(6).align = :right
              column(2).align = :center
          end
          entries.each do |entry| 
            table([["#{entry.entry_date.strftime("%b %e, %Y")}", 
              "#{entry.description.truncate(80)}", 
              "#{entry.reference_number}",
              "#{display_commercial_document_for(entry).try(:upcase)}",
              "ACCOUNT", "DEBIT", "CREDIT"]], 
              cell_style: { inline_format: true, size: 9, padding: [1,1,1,1]}, 
              column_widths: [40, 135, 50, 70, 100, 70, 70]) do
              cells.borders = [:top]
              column(2).align = :center
              column(6).align = :right
              column(5).align = :right
              column(4).align = :center
              column(6).font_style = :bold
              column(5).font_style = :bold
              column(4).font_style = :bold
              style column(4), :size => 7
              style column(5), :size => 7
              style column(6), :size => 7

            end
            amounts(entry)
          end
          table_footer
          
        end
      end

      def amounts(entry)
        amounts_data = entry.debit_amounts.map{|a| ["", "", "", "", a.account.name, price(a.amount), ""] } + 
                       entry.credit_amounts.map{|a| ["", "", "", "", a.account.name, "", price(a.amount)] }
        table_data = [*amounts_data]
        table(table_data, cell_style: { size: 8, padding: [1,1,3,1]}, 
          column_widths: [40, 135, 50, 70, 100, 70, 70]) do
            cells.borders = []
            column(6).align = :right
            column(5).align = :right
        end
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
        table([["", "", "", "",  "SUB-TOTAL", 
          "#{price(entry.debit_amounts.sum{|a| a.amount})}", 
          "#{price(entry.credit_amounts.sum{|a| a.amount})}"]], 
          cell_style: { inline_format: true, size: 8, font: "Helvetica", padding: [1,1,4,1]}, 
          column_widths: [40, 135, 50, 70, 100, 70, 70]) do
            row(0).font_style= :bold
            row(0).background_color = 'DDDDDD'
            cells.borders = []
            column(5).align = :right
            column(6).align = :right
        end
      end

      def table_footer
        total_debit_amounts = entries.sum {|e| e.debit_amounts.sum {|d| d.amount}}
        total_credit_amounts = entries.sum {|e| e.credit_amounts.sum {|c| c.amount}}
        table([["", "", "", "", "", price(total_debit_amounts), price(total_credit_amounts)]], 
          cell_style: { inline_format: true, size: 8, font: "Helvetica", padding: [4,1,4,1]}, 
          column_widths: [50, 135, 50, 70, 90, 70, 70]) do
            row(0).font_style= :bold
            row(0).background_color = 'DDDDDD'
            cells.borders = [:top]
            column(5).align = :right
            column(6).align = :right
            column(2).align = :center
        end
      end
    end
  end
end
