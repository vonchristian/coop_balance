module TellerDepartment
  class PaymentsController < ApplicationController
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @payment = SupplierPaymentForm.new
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @payment = SupplierPaymentForm.new(payment_params)
      if @payment.valid?
        @payment.save
        redirect_to teller_department_supplier_url(@supplier), notice: "Success"
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:supplier_payment_form).permit(:reference_number, :date, :amount, :supplier_id)
    end
  end
end
