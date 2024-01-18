module AccountingModule
  class EntriesPdf < Prawn::Document
    attr_reader :entries, :employee, :title, :view_context, :cooperative, :cooperative_service, :from_date, :to_date, :organization

    def initialize(args)
      super(margin: [60, 20, 20, 20], page_size: [612, 936], page_layout: :landscape)
      @entries      = args[:entries]
      @employee     = args[:employee]
      @cooperative  = args[:cooperative]
      @cooperative_service = args[:cooperative_service] if args[:cooperative_service].present?
      @view_context = args[:view_context]
      @from_date    = args[:from_date]
      @to_date      = args[:to_date]
      @organization = args[:organization]
      @title        = args[:title]

      heading
      summary
      entries_table
      accounts_summary
      font Rails.root.join('app/assets/fonts/open_sans_regular.ttf')
    end

    private

    def ledgers
      ids = entries.amounts.pluck(:account_id)
      ledger_ids = AccountingModule::Account.where(id: ids.uniq.compact.flatten).pluck(:ledger_id)
      AccountingModule::Ledger.where(id: ledger_ids.uniq.compact.flatten)
    end

    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:name_and_initial)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:name_and_initial)
      else
        entry.commercial_document.try(:name)
      end
    end

    def price(number)
      view_context.number_to_currency(number, unit: 'P ')
    end

    def logo
      { image: Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, image_width: 50, image_height: 50 }
    end

    def subtable_right
      sub_data ||= [[{ content: cooperative.abbreviated_name.to_s, size: 22 }]] + [[{ content: cooperative.name.to_s, size: 10 }]]
      make_table(sub_data, cell_style: { padding: [0, 5, 1, 2] }) do
        columns(0).width = 140
        cells.borders = []
      end
    end

    def subtable_left
      sub_data ||= [[{ content: title.to_s, size: 14, colspan: 2 }]] +
                   [[{ content: cooperative_service.try(:title).to_s, size: 12, colspan: 2 }]] +
                   [[{ content: 'From:', size: 10 }, { content: from_date.strftime('%b. %e, %Y').to_s, size: 10 }]] +
                   [[{ content: 'To:', size: 10 }, { content: to_date.strftime('%b. %e, %Y').to_s, size: 10 }]]
      make_table(sub_data, cell_style: { padding: [0, 5, 1, 2] }) do
        columns(0).width = 80
        columns(1).width = 230
        cells.borders = []
      end
    end

    # 275, 50, 210
    def heading
      bounding_box [bounds.left, bounds.top], width: 936 do
        table([[subtable_left, logo, subtable_right]],
              cell_style: { inline_format: true, font: 'Helvetica', padding: [0, 5, 0, 0] },
              column_widths: [686, 50, 140]) do
          cells.borders = []
        end
      end
      stroke do
        move_down 3
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 1
      end
      move_down 10
    end

    def summary
      text 'SUMMARY', size: 10, style: :bold
      move_down 5
      text 'ENTRIES COUNT', size: 8
      text entries.count.to_s, size: 14
      move_down 5
    end

    def entries_table_header
      table([['DATE', { content: 'PARTICULARS', colspan: 2 }, 'REF. NO.', 'ACCOUNT', 'DEBIT', 'CREDIT']],
            cell_style: { inline_format: true, size: 10, font: 'Helvetica', padding: [4, 1, 4, 1] },
            column_widths: [40, 130, 250, 86, 230, 70, 70]) do
        cells.borders = []
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
        cells.borders = %i[top bottom]
        column(5).align = :right
        column(6).align = :right
        column(3).align = :center
        column(1).align = :center
      end
    end

    def entries_table_footer
      table([['', '', '', '', 'TOTAL', price(@entries.debit_amounts.total), price(@entries.credit_amounts.total)]],
            cell_style: { inline_format: true, size: 10, font: 'Helvetica', padding: [4, 1, 4, 1] },
            column_widths: [40, 130, 250, 86, 230, 70, 70]) do
        row(0).font_style = :bold
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
        text 'No entries data.', align: :center
      else
        entries_table_header
        entries.sort_by(&:ascending_order).each do |entry|
          same_reference_entries = entries.where(reference_number: entry.reference_number).sort_by(&:ascending_order)
          table([[entries_table_data(entry), amounts_table_data(entry)]],
                cell_style: { inline_format: true, size: 10, padding: [1, 1, 3, 1] },
                column_widths: [506, 370]) do
            cells.borders = [:top]
          end
          next unless same_reference_entries.count > 1 && (same_reference_entries.last == entry)

          table([['', "(#{same_reference_entries.count})SUB-TOTAL (##{entry.reference_number})", price(same_reference_entries.sum { |e| e.debit_amounts.sum(&:amount) }),
                  price(same_reference_entries.sum { |e| e.credit_amounts.sum(&:amount) })]],
                cell_style: { inline_format: true, size: 10, padding: [1, 1, 3, 1] },
                column_widths: [506, 230, 70, 70]) do
            cells.borders = [:top]
            row(0).font_style = :bold
            column(3).align = :right
            column(2).align = :right
          end
        end
        entries_table_footer
      end
    end

    def entries_table_data(entry)
      entries_data = [[
        { content: entry.entry_date.strftime('%D') },
        { content: display_commercial_document_for(entry).try(:upcase) },
        { content: entry.description },
        { content: "##{entry.reference_number}" }
      ]]
      make_table(entries_data,
                 cell_style: { inline_format: true, size: 10, font: 'Helvetica', padding: [1, 1, 3, 1] },
                 column_widths: [40, 130, 250, 86]) do
        cells.borders = []
        column(3).align = :center
      end
    end

    def amounts_table_data(entry)
      row_count = entry.amounts.count
      debit_amounts_data = if entry.debit_amounts.present?
                             entry.debit_amounts.map { |a| [a.account.display_name, price(a.amount), ''] }
                           else
                             [['']]
                           end
      credit_amounts_data = if entry.credit_amounts.present?
                              entry.credit_amounts.map { |a| [a.account.display_name, '', price(a.amount)] }
                            else
                              [['']]
                            end

      make_table(debit_amounts_data + credit_amounts_data,
                 cell_style: { inline_format: true, size: 10, font: 'Helvetica', padding: [1, 1, 3, 1] },
                 column_widths: [230, 70, 70]) do
        cells.borders = []
        column(1).align = :right
        column(2).align           = :right
        row(row_count).borders    = [:top]
        row(row_count).font_style = :bold
      end
    end

    def accounts_summary
      start_new_page
      text 'ACCOUNTS SUMMARY', size: 10, style: :bold
      table([%w[ACCOUNT DEBITS CREDITS]] +
      ledgers.updated_at(from_date: @from_date, to_date: @to_date).distinct.map { |ledger| [ledger.name, price(ledger.debit_amounts.where(entry_id: @entries.ids).entered_on(from_date: @from_date, to_date: @to_date).total), price(ledger.credit_amounts.where(entry_id: @entries.ids).entered_on(from_date: @from_date, to_date: @to_date).total)] }, column_widths: [500, 150, 150]) do
        column(1).align = :right
        column(2).align = :right
        row(0).font_size = 10
        row(0).font_style = :bold
      end
      table([['TOTAL', price(@entries.debit_amounts.total), price(@entries.credit_amounts.total)]], column_widths: [500, 150, 150]) do
        column(1).align = :right
        column(2).align = :right
      end

      string = 'page <page> of <total>'
      options = { at: [bounds.right - 150, 0],
                  width: 150,
                  size: 10,
                  align: :right,
                  start_count_at: 1,
                  color: '000000' }
      number_pages string, options
    end
  end
end
