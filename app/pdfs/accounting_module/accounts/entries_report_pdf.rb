module AccountingModule
  module Accounts
    class EntriesReportPdf < Prawn::Document
      attr_reader :entries, :account, :employee, :from_date, :to_date, :view_context, :cooperative

      def initialize(args)
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @entries      = args[:entries]
        @account      = args[:account]
        @employee     = args[:employee]
        @cooperative  = @employee.cooperative
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @view_context = args[:view_context]
        heading
        entries_table
        font Rails.root.join("app/assets/fonts/open_sans_regular.ttf")
      end

      private

      def debit_amount_for(amount)
        return unless amount.debit?

        price(amount.amount)
      end

      def credit_amount_for(amount)
        return unless amount.credit?

        price(amount.amount)
      end

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
        bounding_box [ 300, 770 ], width: 50 do
          image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 50, height: 50
        end
        bounding_box [ 360, 770 ], width: 200 do
          text cooperative.abbreviated_name.to_s, style: :bold, size: 20
          text cooperative.name.try(:upcase).to_s, size: 8
          text cooperative.address.to_s, size: 8
        end
        bounding_box [ 0, 770 ], width: 400 do
          text "Entries Report", style: :bold, size: 12
          text "Account: #{account.name.upcase}", size: 10
          text "Date: #{from_date.strftime('%B %e, %Y')} - #{to_date.strftime('%B %e, %Y')}", size: 10
          text "Total Debits: #{price(entries.debit_amounts.total)}", size: 10
          text "Total Credits: #{price(entries.credit_amounts.total)}", size: 10
        end
        move_down 20
        stroke do
          stroke_color "24292E"
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
      end

      def entries_table_header
        table([ [ "DATE", "DESCRIPTION", "REF. NO.", "MEMBER/PAYEE", "ACCOUNT", "DEBIT", "CREDIT" ] ],
              cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [ 4, 1, 4, 1 ] },
              column_widths: [ 40, 135, 50, 70, 100, 70, 70 ]) do
          row(0).font_style = :bold
          row(0).background_color = "DDDDDD"
          cells.borders = %i[top bottom]
          column(5).align = :right
          column(6).align = :right
          column(2).align = :center
          column(1).align = :center
          column(4).align = :center
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
              price(entry.debit_amounts.total).to_s,
              price(entry.credit_amounts.total).to_s
            ] ]
            entries_data = [ [
              { content: entry.entry_date.strftime("%b %e, %Y"), rowspan: row_count },
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
