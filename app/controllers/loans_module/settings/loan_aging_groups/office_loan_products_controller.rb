module LoansModule
  module Settings 
    module LoanAgingGroups 
      class OfficeLoanProductsController < ApplicationController
        def new 
          @loan_aging_group              = current_office.loan_aging_groups.find(params[:loan_aging_group_id])
          @loan_aging_group_loan_product = @loan_aging_group.office_loan_product_aging_groups.build 
        end 

        def create 
          @loan_aging_group              = current_office.loan_aging_groups.find(params[:loan_aging_group_id])
          @loan_aging_group_loan_product = @loan_aging_group.office_loan_product_aging_groups.create(office_loan_product_aging_group_params)
          if @loan_aging_group_loan_product.valid?
            @loan_aging_group_loan_product.save!
            
            redirect_to loans_module_settings_url, notice: 'saved successfully'
          else 
            render :new 
          end 
        end 

        private 
        def office_loan_product_aging_group_params
          params.require(:loans_module_office_loan_product_aging_group).
          permit(:office_loan_product_id, :level_one_account_category_id)
        end 
      end 
    end 
  end 
end 