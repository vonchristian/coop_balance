module AccountingModule
  module Reports
    class FinancialConditionPdf < Prawn::Document
      attr_reader :from_date, :to_date, :assets, :liabilities, :equities, :employee, :view_context, :cooperative, :office
      def initialize(args)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @assets       = args[:assets]
        @liabilities  = args[:liabilities]
        @equities     = args[:equities]
        @employee     = args[:employee]
        @cooperative  = @employee.cooperative
        @office       = @employee.office
        @view_context = args[:view_context]
        heading
        asset_accounts
        liabilities_accounts
        equities_accounts
        total_liabilities_and_equities
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end

      def logo
        {image: "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", image_width: 50, image_height: 50}
      end

      def subtable_right
        sub_data ||= [[{content: "#{cooperative.abbreviated_name}", size: 22}]] + [[{content: "#{cooperative.name}", size: 10}]]
        make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
          columns(0).width = 180
          cells.borders = []
        end
      end

      def subtable_left
        sub_data ||= [[{content: "FINANCIAL CONDITION", size: 14, colspan: 2}]] +
                      [[{content: "As of #{to_date.strftime("%b. %e, %Y")}", size: 10, colspan: 2}]]
        make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
          columns(0).width = 50
          columns(1).width = 150
          cells.borders = []
        end
      end

      def heading # 275, 50, 210
        bounding_box [bounds.left, bounds.top], :width  => 535 do
          table([[subtable_left, logo, subtable_right]],
            cell_style: { inline_format: true, font: "Helvetica", padding: [0,5,0,0]},
            column_widths: [310, 50, 180]) do
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

      def asset_accounts
        text "ASSETS", size: 12, style: :bold
        move_down 5

        text "CURRENT ASSETS", size: 11, :indent_paragraphs => 10

        table(current_assets_data, header: false, 
          cell_style: { size: 9, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 2
        table(total_current_assets_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 4
        text "NON-CURRENT ASSETS", size: 11, :indent_paragraphs => 10
        table(non_current_assets_data, header: false, 
          cell_style: { size: 9, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 2
        table(total_non_current_assets_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 2
        table(total_assets_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:top, :bottom]
          column(5).align = :right
        end
      end

      def current_assets_data
        current_assets = []
        office.accounts.active.current_assets.each do |account|
          
          if account.main_account.blank? #base account
            current_assets << ["", "", {content: account.name, colspan: 3, font_style: :bold}, account_balance(account)]
          elsif account.main_account.present? && account.main_account.main_account.blank? #sub_base
            if !account.balance(to_date: to_date).zero?
              current_assets << ["", "", "", {content: account.name, colspan: 2}, account_balance(account)]
            else 
              if !office.accounts.active.assets.sub_accounts_for(account: account).balance(to_date: to_date).zero?
                current_assets << ["", "", "", {content: account.name, colspan: 2}, ""]
              end
            end
          elsif account.main_account.main_account.present? #sub_account
            if !account.balance(to_date: to_date).zero?
              current_assets << ["", "", "", "", account.name, price(account.balance(to_date: to_date))]
            end
          end
        end
        current_assets
      end

      def non_current_assets_data
        non_current_assets = []
        office.accounts.active.non_current_assets.each do |account|
          
          if account.main_account.blank? #base account
            non_current_assets << ["", "", {content: account.name, colspan: 3, font_style: :bold}, account_balance(account)]
          elsif account.main_account.present? && account.main_account.main_account.blank? #sub_base
            if !account.balance(to_date: to_date).zero?
              non_current_assets << ["", "", "", {content: account.name, colspan: 2}, account_balance(account)]
            else 
              if !office.accounts.active.assets.sub_accounts_for(account: account).balance(to_date: to_date).zero?
                non_current_assets << ["", "", "", {content: account.name, colspan: 2}, ""]
              end
            end
          elsif account.main_account.main_account.present? #sub_account
            if !account.balance(to_date: to_date).zero?
              non_current_assets << ["", "", "", "", account.name, price(account.balance(to_date: to_date))]
            end
          end
        end
        non_current_assets
      end

      def total_current_assets_data
        [["", "", {content: "Total Current Assets", colspan: 3, font_style: :bold}, "<b>#{price(AccountingModule::Asset.active.current_assets.balance(to_date: to_date))}</b>"]]
      end

      def total_non_current_assets_data
        [["", "", {content: "Total Non-Current Assets ", colspan: 3, font_style: :bold}, "<b>#{price(AccountingModule::Asset.active.non_current_assets.balance(to_date: to_date))}</b>"]]
      end

      def total_assets_data
        [["", {content: "TOTAL ASSETS ", colspan: 4, font_style: :bold}, "<b>#{price(AccountingModule::Asset.active.balance(to_date: to_date))}</b>"]]
      end

      def liabilities_accounts
        move_down 30
        text "LIABILITIES AND MEMBERS' EQUITY", size: 10, style: :bold
        move_down 5
        text "LIABILITIES", size: 12, style: :bold
        move_down 5

        text "CURRENT LIABILITIES", size: 11, :indent_paragraphs => 10

        table(current_liabilities_data, header: false, 
          cell_style: { size: 9, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 2
        table(total_current_liabilities_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 4
        text "NON-CURRENT LIABILITIES", size: 11, :indent_paragraphs => 10
        table(non_current_liabilities_data, header: false, 
          cell_style: { size: 9, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 2
        table(total_non_current_liabilities_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:bottom]
          column(5).align = :right
        end
        move_down 2
        table(total_liabilities_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = [:top, :bottom]
          column(5).align = :right
        end
      end

      def current_liabilities_data
        current_liabilities = []
        office.accounts.active.current_liabilities.each do |account|
          
          if account.main_account.blank? #base account
            current_liabilities << ["", "", {content: account.name, colspan: 3, font_style: :bold}, account_balance(account)]
          elsif account.main_account.present? && account.main_account.main_account.blank? #sub_base
            if !account.balance(to_date: to_date).zero?
              current_liabilities << ["", "", "", {content: account.name, colspan: 2}, account_balance(account)]
            else 
              if !office.accounts.active.liabilities.sub_accounts_for(account: account).balance(to_date: to_date).zero?
                current_liabilities << ["", "", "", {content: account.name, colspan: 2}, ""]
              end
            end
          elsif account.main_account.main_account.present? #sub_account
            if !account.balance(to_date: to_date).zero?
              current_liabilities << ["", "", "", "", account.name, price(account.balance(to_date: to_date))]
            end
          end
        end
        current_liabilities
      end

      def non_current_liabilities_data
        non_current_liabilities = []
        office.accounts.active.non_current_liabilities.each do |account|
          
          if account.main_account.blank? #base account
            non_current_liabilities << ["", "", {content: account.name, colspan: 3, font_style: :bold}, account_balance(account)]
          elsif account.main_account.present? && account.main_account.main_account.blank? #sub_base
            if !account.balance(to_date: to_date).zero?
              non_current_liabilities << ["", "", "", {content: account.name, colspan: 2}, account_balance(account)]
            else 
              if !office.accounts.active.liabilities.sub_accounts_for(account: account).balance(to_date: to_date).zero?
                non_current_liabilities << ["", "", "", {content: account.name, colspan: 2}, ""]
              end
            end
          elsif account.main_account.main_account.present? #sub_account
            if !account.balance(to_date: to_date).zero?
              non_current_liabilities << ["", "", "", "", account.name, price(account.balance(to_date: to_date))]
            end
          end
        end
        non_current_liabilities
      end

      def total_current_liabilities_data
        [["", "", {content: "Total Current Liabilities", colspan: 3, font_style: :bold}, "<b>#{price(AccountingModule::Liability.active.current_liabilities.balance(to_date: to_date))}</b>"]]
      end

      def total_non_current_liabilities_data
        [["", "", {content: "Total Non-Current Liabilities ", colspan: 3, font_style: :bold}, "<b>#{price(AccountingModule::Liability.active.non_current_liabilities.balance(to_date: to_date))}</b>"]]
      end

      def total_liabilities_data
        [["", {content: "TOTAL LIABILITIES ", colspan: 4, font_style: :bold}, "<b>#{price(AccountingModule::Liability.active.balance(to_date: to_date))}</b>"]]
      end

      def equities_accounts
        move_down 10
        text "EQUITY", size: 12, style: :bold

        table(equities_data, header: false, 
          cell_style: { size: 9, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 371, 100]) do
          cells.borders = [:bottom]
          column(4).align = :right
        end
        move_down 2
        table(total_equities_data, header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 371, 100]) do
          cells.borders = [:top, :bottom]
          column(4).align = :right
        end
      end

      def equities_data
        members_equities = []
        office.accounts.active.equities.order(:code).each do |account|
          
          if account.main_account.blank? #base account
            members_equities << ["", {content: account.name, colspan: 3, font_style: :bold}, account_balance(account)]
          elsif account.main_account.present? && account.main_account.main_account.blank? #sub_base account
            if !account.balance(to_date: to_date).zero?
              members_equities << ["", "","", {content: account.name}, account_balance(account)]
            else 
              if !office.accounts.active.equities.sub_accounts_for(account: account).balance(to_date: to_date).zero?
                members_equities << ["", "", {content: account.name, colspan: 2}, ""]
              end
            end
          elsif account.main_account.main_account.present? #sub_base_sub_account
            if !account.balance(to_date: to_date).zero?
              members_equities << ["", "", "", account.name, price(account.balance(to_date: to_date))]
            end
          end
        end
        members_equities
      end
      def total_equities_data
        [["", {content: "TOTAL EQUITIES ", colspan: 3, font_style: :bold}, "<b>#{price(AccountingModule::Equity.active.balance(to_date: to_date))}</b>"]]
      end

      def total_liabilities_and_equities(options={})
        move_down 10
        table(liabilities_and_equities_data(options), header: true, 
          cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
          column_widths: [10, 10, 10, 10, 361, 100]) do
          cells.borders = []
          column(1).align = :right
        end
      end

      def liabilities_and_equities_data(options={})
        [[{content: "TOTAL LIABILITIES AND EQUITIES", colspan: 5, font_style: :bold}, "<b>#{price(liabilities_and_equities_total(options))}</b>"]]
      end

      def liabilities_and_equities_total(options={})
        AccountingModule::Liability.active.balance(to_date: to_date) +
        AccountingModule::Equity.active.balance(to_date: to_date)
      end      

      def account_balance(account)
        if !account.balance(to_date: to_date).zero?
          price(account.balance(to_date: to_date))
        else
          ""
        end
      end
    end
  end
end
