module LoansModule
  module Settings
    class LoanAgingGroupsController < ApplicationController
      def new
        @loan_aging_group = current_office.loan_aging_groups.build
      end

      def create
        @loan_aging_group = current_office.loan_aging_groups.create(loan_aging_group_params)
        if @loan_aging_group.valid?
          @loan_aging_group.save!
          redirect_to loans_module_settings_url, notice: 'Loan aging group created successfully.'
        else
          render :new
        end
      end

      def show 
        @loan_aging_group = current_office.loan_aging_groups.find(params[:id])
      end 

      def edit
        @loan_aging_group = current_office.loan_aging_groups.find(params[:id])
      end 

      def update 
        @loan_aging_group = current_office.loan_aging_groups.find(params[:id])
        @loan_aging_group.update(loan_aging_group_params)
        if @loan_aging_group.valid?
          @loan_aging_group.save!
          redirect_to loans_module_settings_loan_aging_group_url(@loan_aging_group), notice: 'updated successfully'
        end 
      end 

      private
      def loan_aging_group_params
        params.require(:loans_module_loan_aging_group).
        permit(:title, :start_num, :end_num, :ledger_id)
      end
    end
  end
end
