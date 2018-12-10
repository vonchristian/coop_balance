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
    bounding_box [300, 770], width: 50 do
      image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
    end
    bounding_box [360, 770], width: 200 do
        text "#{cooperative.abbreviated_name }", style: :bold, size: 20
        text "#{cooperative.name.try(:upcase)}", size: 8
        text "#{cooperative.address}", size: 8
    end
    bounding_box [0, 770], width: 400 do
      text "Entries Report", style: :bold, size: 12
      text "Account: #{account.name.upcase}", size: 10
      text "Date: #{from_date.strftime("%B %e, %Y")} - #{to_date.strftime("%B %e, %Y")}", size: 10
    end
    move_down 20
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 5
    end
  end

      def entries_table
        if !@entries.any?
          move_down 10
          text "No entries data.", align: :center
        else
          table([["DATE", "DESCRIPTION", "REFERENCE", "MEMBER/PAYEE",  "ACCOUNT", "AMOUNT"]], cell_style: { inline_format: true, size: 6, font: "Helvetica"}, column_widths: [50, 150, 50, 100,  100, 80]) do
            row(0).font_style= :bold
            row(0).background_color = 'DDDDDD'
          end
          entries.each do |entry|
            table([["#{entry.entry_date.strftime("%b %e, %Y")}", "#{entry.description}", "#{entry.reference_number}",  "#{display_commercial_document_for(entry)}",]], cell_style: { size: 9, padding: [5,5,4,0]}, column_widths: [50, 150, 50,  100,  100, 80]) do
              cells.borders = []
            end
            table([["", "", "", "", "", "<b>DEBIT</b>"]]+
              entry.debit_amounts.map{|a| ["", "", "",  "", "", a.account.name,  price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: { inline_format: true, size: 8, padding: [0,0,0,0]}) do
              cells.borders = []
              column(-1).align = :right
            end
            table([["",  "", "","", "", "<b>CREDIT</b>"]] + entry.credit_amounts.map{|a| ["", "", "",  "", "",  a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: {inline_format: true, padding: [0,0,2,0], size: 8} ) do
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
end
