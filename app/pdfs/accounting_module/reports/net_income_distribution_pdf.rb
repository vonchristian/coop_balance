module AccountingModule
  module Reports
    class NetIncomeDistributionPdf < Prawn::Document
      attr_reader :from_date,:to_date, :accounts, :view_context, :employee, :cooperative, :net_income, :net_income_distributions
      def initialize(args)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @from_date                = args[:from_date]
        @to_date                  = args[:to_date]
        @accounts                 = args[:accounts]
        @employee                 = args[:employee]
        @net_income               = args[:net_income]
        @net_income_distributions = args[:net_income_distributions]
        @view_context             = args[:view_context]
        @cooperative              = @employee.cooperative
        heading
        net_income_details
        distribution_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [300, 760], width: 50 do
          image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 40, height: 40
        end
        bounding_box [350, 760], width: 150 do
            text "#{cooperative.abbreviated_name.upcase}", style: :bold, size: 22
            text "#{cooperative.address}", size: 10
        end
        bounding_box [0, 760], width: 400 do
          text "Net Income Distribution Report", style: :bold, size: 14
          move_down 5
          text "#{from_date.strftime("%B %e, %Y")} - #{to_date.strftime("%B %e, %Y")} ", size: 10
          move_down 5
        end
        move_down 10
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
      def net_income_details
        text "#{price(net_income)}", size: 20
        text "Net Income", size: 10
        stroke do
          move_down 5
          stroke_color 'CCCCCC'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
      end
      def distribution_table
        table(net_income_distributions_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [280, 100, 100]) do
          cells.borders =[]
          column(1).align = :right
          column(2).align = :right
          row(0).font_style = :bold

        end
        stroke do
          move_down 5
          stroke_color 'CCCCCC'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end

      end
      def net_income_distributions_data
        [["Account", "Rate", "Amount"]] +
        @net_income_distributions_data ||= net_income_distributions.map{|a| [a.description, "#{a.percent} %", price(a.amount_for(net_income))] }
      end
    end
  end
end
