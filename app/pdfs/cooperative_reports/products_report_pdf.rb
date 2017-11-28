module CooperativeReports
  class ProductsReportPdf < Prawn::Document
    def initialize(saving_products, view_context)
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @saving_products = saving_products
      @view_context = view_context
      heading
      saving_products_table
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading
      bounding_box [300, 780], width: 50 do
        image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
      end
      bounding_box [370, 780], width: 200 do
          text "KCMDC", style: :bold, size: 24
          text "Kiangan Community Multipurpose Cooperative", size: 10
      end
      bounding_box [0, 780], width: 400 do
        text "Cooperative Products Analysis", style: :bold, size: 14
        move_down 3
         text "", size: 10
        move_down 3

        text "Employee:", size: 10
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end

    def saving_products_table
      if @saving_products.blank?
        move_down 10
        text "No saving_products data.", align: :center
      else
        text "SAVINGS PRODUCTS", size: 10, style: :bold
        move_down 10
        stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
        end
        table(savings_products_table_data, header: true, cell_style: { size: 9, font: "Helvetica"}) do
          cells.borders = []
          # row(0).font_style = :bold
          # row(0).background_color = 'DDDDDD'

        end
      end
    end
    def savings_products_table_data
      move_down 5
      [["PRODUCT NAME", "NO. OF ACCOUNTS", "DEPOSITS", "WITHDRAWALS", "BALANCE"]] +
      @savings_products_table_data ||= @saving_products.map { |e| [e.name, e.subscribers.updated_at(from_date: Time.zone.now.beginning_of_day, to_date: Time.zone.now.end_of_day).count, price(e.account.credits_balance(to_date: Time.zone.now.end_of_day)), price(e.account.debits_balance(to_date: Time.zone.now.end_of_day)), price(e.account.balance(to_date: Time.zone.now.end_of_day))]} +
      [["TOTAL", "#{CoopServicesModule::SavingProduct.total_subscribers}"]]
    end
  end
end
