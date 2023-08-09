module Merchants
  class PaymentLineItemsController < ApplicationController
    def new
      @commercial_document = params[:commercial_document_type].constantize.find(params[:commercial_document_id])
      @merchant = current_cooperative.merchants.find(params[:merchant_id])
      @payment_line_item = Merchants::PaymentLineItem.new
    end
    def create
      @commercial_document = params[:merchants_payment_line_item][:commercial_document_type].constantize.find(params[:merchants_payment_line_item][:commercial_document_id])
      @merchant            = current_cooperative.merchants.find(params[:merchant_id])
      @payment_line_item   = Merchants::PaymentLineItem.new(payment_line_item_params)
      if @payment_line_item.valid?
        @payment_line_item.process!
        redirect_to new_merchant_payment_line_item_url(merchant_id: @merchant.id, commercial_document_type: @commercial_document.class.to_s, commercial_document_id: @commercial_document.id), notice: "created successfully"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def payment_line_item_params
      params.require(:merchants_payment_line_item).
      permit(:description, :amount, :merchant_id, :commercial_document_type, :commercial_document_id, :merchant_id, :employee_id, :reference_number)
    end
  end
end
