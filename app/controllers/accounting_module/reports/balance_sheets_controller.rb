module AccountingModule
  module Reports
    class BalanceSheetsController < ApplicationController
      def index
        first_entry = current_cooperative.entries.order('entry_date ASC').first
        @from_date  = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date    = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : Date.current
       
       
        respond_to do |format|
          format.html # index.html.erb
          format.csv { render_csv }
          format.pdf do
            pdf = AccountingModule::Reports::BalanceSheetPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              office: current_office,
              view_context: view_context,
              cooperative:  current_cooperative)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Balance Sheet.pdf"
          end
        end
      end 

      private 

      def render_csv
        # Tell Rack to stream the content
        headers.delete("Content-Length")
  
        # Don't cache anything from this generated endpoint
        headers["Cache-Control"] = "no-cache"
  
        # Tell the browser this is a CSV file
        headers["Content-Type"] = "text/csv"
  
        # Make the file download with a specific filename
        headers["Content-Disposition"] = "attachment; filename=\"Loans Portfolio.csv\""
  
        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"
  
        # Set an Enumerator as the body
        self.response_body = csv_body
  
        response.status = 200
      end
  
  
      def csv_body
        net_surplus       = (current_office.level_one_account_categories.revenues.balance(from_date: @to_date.beginning_of_year, to_date: @to_date)-current_office.level_one_account_categories.expenses.balance(from_date: @to_date.beginning_of_year, to_date: @to_date))
        total_assets      = BigDecimal('0')
        total_liabilities = BigDecimal('0')
        total_equities    = BigDecimal('0')

        Enumerator.new do |yielder|
          assets_body
          yielder << CSV.generate_line(["#{current_office.name} - Balance Sheet"])
          yielder << CSV.generate_line(["AS OF: #{@to_date.strftime('%B %e, %Y')}"])
          yielder << CSV.generate_line(["ASSETS"])

          current_office.level_three_account_categories.assets.order(code: :asc).each do |l3_account_category|
            yielder << CSV.generate_line([l3_account_category.title])
            
            l3_account_category.level_two_account_categories.assets.order(code: :asc).each do |l2_account_category|
              yielder << CSV.generate_line(["    #{l2_account_category.title}"])
              
              l2_account_category.level_one_account_categories.assets.order(code: :asc).each do |l1_account_category|
                total_assets += l1_account_category.balance(to_date: @to_date)
                
                yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
              end

              yielder << CSV.generate_line(["    Total #{l2_account_category.title}", l2_account_category.balance(to_date: @to_date)])
              yielder << CSV.generate_line([""])
            end

            yielder << CSV.generate_line(["Total #{l3_account_category.title}", l3_account_category.balance(to_date: @to_date)])
          end

          current_office.level_two_account_categories.assets.where.not(id: current_office.level_three_account_categories.level_two_account_categories.assets.ids).order(code: :asc).each do |l2_account_category|
            yielder << CSV.generate_line(["    #{l2_account_category.title}"])
            
            l2_account_category.level_one_account_categories.assets.order(code: :asc).each do |l1_account_category|
              total_assets += l1_account_category.balance(to_date: @to_date)
              yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
            end

            yielder << CSV.generate_line(["    Total #{l2_account_category.title}", l2_account_category.balance(to_date: @to_date)])
            yielder << CSV.generate_line([""])
          end

          current_office.level_one_account_categories.assets.where.not(id: current_office.level_two_account_categories.level_one_account_categories.assets.ids).order(code: :asc).each do |l1_account_category|
            total_assets += l1_account_category.balance(to_date: @to_date)
              yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
          end
            yielder << CSV.generate_line(["TOTAL ASSETS", total_assets])
            yielder << CSV.generate_line([""])

            #Liabilities 
            yielder << CSV.generate_line([""])

            yielder << CSV.generate_line(["LIABILITIES"])
            current_office.level_three_account_categories.liabilities.order(code: :asc).each do |l3_account_category|
              yielder << CSV.generate_line([l3_account_category.title])
              l3_account_category.level_two_account_categories.liabilities.order(code: :asc).each do |l2_account_category|
                yielder << CSV.generate_line(["    #{l2_account_category.title}"])
                
                l2_account_category.level_one_account_categories.liabilities.order(code: :asc).each do |l1_account_category|
                  total_liabilities += l1_account_category.balance(to_date: @to_date)
                  yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
                end
  
                yielder << CSV.generate_line(["    Total #{l2_account_category.title}", l2_account_category.balance(to_date: @to_date)])
              end
              yielder << CSV.generate_line(["Total #{l3_account_category.title}", l3_account_category.balance(to_date: @to_date)])
            end
  
            current_office.level_two_account_categories.liabilities.where.not(id: current_office.level_three_account_categories.level_two_account_categories.liabilities.ids).order(code: :asc).each do |l2_account_category|
              yielder << CSV.generate_line(["    #{l2_account_category.title}"])
              l2_account_category.level_one_account_categories.liabilities.order(code: :asc).each do |l1_account_category|
                total_liabilities += l1_account_category.balance(to_date: @to_date)
                yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
              end
  
              yielder << CSV.generate_line(["    Total #{l2_account_category.title}", l2_account_category.balance(to_date: @to_date)])
            end
  
            current_office.level_one_account_categories.liabilities.where.not(id: current_office.level_two_account_categories.level_one_account_categories.liabilities.ids).order(code: :asc).each do |l1_account_category|
              total_liabilities += l1_account_category.balance(to_date: @to_date)
                yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
            end
            yielder << CSV.generate_line(["TOTAL LIABILITIES", total_liabilities])

            #Equities 

            yielder << CSV.generate_line([""])

            yielder << CSV.generate_line(["EQUITY"])
            current_office.level_three_account_categories.equities.order(code: :asc).each do |l3_account_category|
              yielder << CSV.generate_line([l3_account_category.title])
              l3_account_category.level_two_account_categories.equities.order(code: :asc).each do |l2_account_category|
                yielder << CSV.generate_line(["    #{l2_account_category.title}"])
                
                l2_account_category.level_one_account_categories.equities.order(code: :asc).each do |l1_account_category|
                  total_equities += l1_account_category.balance(to_date: @to_date)
                  yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
                end
  
                yielder << CSV.generate_line(["    Total #{l2_account_category.title}", l2_account_category.balance(to_date: @to_date)])
              end
              yielder << CSV.generate_line(["Total #{l3_account_category.title}", l3_account_category.balance(to_date: @to_date)])
            end
  
            current_office.level_two_account_categories.equities.where.not(id: current_office.level_three_account_categories.level_two_account_categories.equities.ids).order(code: :asc).each do |l2_account_category|
              yielder << CSV.generate_line(["    #{l2_account_category.title}"])
              l2_account_category.level_one_account_categories.equities.order(code: :asc).each do |l1_account_category|
                total_equities += l1_account_category.balance(to_date: @to_date)
                yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
              end
  
              yielder << CSV.generate_line(["    Total #{l2_account_category.title}", l2_account_category.balance(to_date: @to_date)])
            end
  
            current_office.level_one_account_categories.equities.where.not(id: current_office.level_two_account_categories.level_one_account_categories.equities.ids).order(code: :asc).each do |l1_account_category|
              total_equities += l1_account_category.balance(to_date: @to_date)
                yielder << CSV.generate_line(["        #{l1_account_category.title}", l1_account_category.balance(to_date: @to_date)])
            end
            yielder << CSV.generate_line(["Undivided Net Surplus", net_surplus])

            yielder << CSV.generate_line(["TOTAL EQUITY", total_equities])
           
            yielder << CSV.generate_line([""])


            yielder << CSV.generate_line(["TOTAL LIABILITIES AND EQUITY", total_liabilities + total_equities, net_surplus])

        end 
      end 
    end
  end
end
