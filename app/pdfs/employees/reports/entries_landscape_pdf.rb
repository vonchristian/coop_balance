module Employees
  module Reports
    class EntriesLandscapePdf < Prawn::Document
      attr_reader :entries, :employee, :from_date, :to_date, :view_context, :cooperative

      def initialize(args)
        super(margin: 30, page_size: "A4", page_layout: :landscape)
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
        view_context.number_to_currency(number, unit: "P ")
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
        bounding_box [ 300, 400 ], width: 50 do
          image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 50, height: 50
        end
        bounding_box [ 370, 400 ], width: 210 do
          text cooperative.abbreviated_name.to_s, style: :bold, size: 22
          text cooperative.name.to_s, size: 10
          move_down 10
        end

        bounding_box [ 0, 400 ], width: 400 do
          text "TRANSACTIONS REPORT", style: :bold, size: 14
          move_down 5
          table([ [ "Employee:", employee.first_middle_and_last_name.to_s ] ],
                cell_style: { padding: [ 0, 0, 1, 0 ], inline_format: true, size: 10 },
                column_widths: [ 50, 150 ]) do
            cells.borders = []
            column(1).font_style = :bold
          end
          table([ [ "From:", from_date.strftime("%B %e, %Y").to_s ] ],
                cell_style: { padding: [ 0, 0, 1, 0 ], inline_format: true, size: 10 },
                column_widths: [ 50, 150 ]) do
            cells.borders = []
            column(1).font_style = :bold
          end
          table([ [ "To:", to_date.strftime("%B %e, %Y").to_s ] ],
                cell_style: { padding: [ 0, 0, 1, 0 ], inline_format: true, size: 10 },
                column_widths: [ 50, 150 ]) do
            cells.borders = []
            column(1).font_style = :bold
          end
        end

        move_down 10
        stroke do
          stroke_color "24292E"
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
      end

      def debit_accounts
        accounts_array = []
        entries.each do |entry|
          entry.debit_accounts.each do |account|
            accounts_array << account.name
          end
        end
        accounts_array
      end

      def credit_accounts
        accounts_array = []
        entries.each do |entry|
          entry.credit_accounts.each do |account|
            accounts_array << account.name
          end
        end
        accounts_array
      end

      # def entries_table_header
      #   thead1 = [["", "", "", "", {content: "DEBIT", align: :center, colspan: debit_accounts.count }, {content: "CREDIT", align: :center, colspan: credit_accounts.count }]]
      #   thead2 = [["DATE", "DESCRIPTION", "REF. NO.", "MEMBER/PAYEE"] + debit_accounts.select {|d| d.name} + credit_accounts.select {|c| c.name}]
      #   table(thead1 + thead2,
      #     cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [4,1,4,1]}) do
      #       row(0).font_style= :bold
      #       row(1).font_style= :bold
      #       row(0).background_color = 'DDDDDD'
      #       row(1).background_color = 'DDDDDD'
      #       cells.borders = []
      #   end
      # end

      def entries_table_header
        [ [ "", "", "", "", { content: "DEBIT", align: :center, colspan: debit_accounts.count }, { content: "CREDIT", align: :center, colspan: credit_accounts.count } ] ]
        thead2 = [ [ "DATE", "DESCRIPTION", "REF. NO.", "MEMBER/PAYEE" ] + debit_accounts.select { |d| d } + credit_accounts.select { |c| c } ]
        table(thead2,
              cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [ 4, 1, 4, 1 ] }) do
          row(0).font_style = :bold
          row(1).font_style = :bold
          row(0).background_color = "DDDDDD"
          row(1).background_color = "DDDDDD"
          cells.borders = []
        end
      end

      def entries_table
        if entries.none?
          move_down 10
          text "No entries data.", align: :center
        else
          entries_table_header

          entries.each do |entry|
            row_count = entry.amounts.count + 1
            debit_amounts_data = entry.debit_amounts.map { |a| [ a.account.name, price(a.amount), "" ] }
            credit_amounts_data = entry.credit_amounts.map { |a| [ a.account.name, "", price(a.amount) ] }
            sub_total = [ [
              "SUB-TOTAL",
              price(entry.debit_amounts.sum(&:amount)).to_s,
              price(entry.credit_amounts.sum(&:amount)).to_s
            ] ]
            entries_data = [ [
              { content: entry.entry_date.strftime("%m/%e/%y"), rowspan: row_count },
              { content: entry.description, rowspan: row_count, valign: :center },
              { content: "##{entry.reference_number}", rowspan: row_count },
              { content: display_commercial_document_for(entry).try(:upcase), rowspan: row_count, valign: :center },
              "", "", ""
            ] ]

            table(entries_data + debit_amounts_data + credit_amounts_data,
                  cell_style: { inline_format: true, size: 8, padding: [ 1, 1, 3, 1 ] },
                  column_widths: [ 40, 135, 50, 70, 100, 70, 70 ]) do
              cells.borders = []
              row(0).height = 1
              column(2).align = :center
              column(6).align = :right
              column(5).align = :right
            end
            stroke do
              stroke_color "24292E"
              line_width 0.5
              stroke_horizontal_rule
              move_down 1
            end
            next unless entry.amounts.count > 2

            table(sub_total, position: :right,
                             cell_style: { inline_format: true, size: 8, padding: [ 1, 1, 3, 1 ] },
                             column_widths: [ 100, 70, 70 ]) do
              cells.borders = []
              row(0).font_style = :bold
              column(1).align = :right
              column(2).align = :right
            end
            stroke do
              stroke_color "24292E"
              line_width 1
              stroke_horizontal_rule
              move_down 1
            end
          end
        end
      end
    end
  end
end
