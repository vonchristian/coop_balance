class SavingsAccountsController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @savings_accounts = pagy(current_office.savings.includes(:saving_product, :liability_account, depositor: [avatar_attachment: [:blob]]).text_search(params[:search]))
    else
      @pagy, @savings_accounts = pagy(current_office.savings.includes(:saving_product, :liability_account, depositor: [avatar_attachment: [:blob]]).order(:account_owner_name))
    end
    @offices = current_cooperative.offices
  end

  def show
    @savings_account = current_office.savings.includes(:liability_account, :office).find(params[:id])
    if params[:search].present?
      @pagy, @entries = pagy(@savings_account.entries.includes(:recorder, :office).order(entry_date: :desc).order(created_at: :desc).text_search(params[:search]))
    else
      @pagy, @entries = pagy(@savings_account.entries.includes(:recorder, :office).order(entry_date: :desc).order(created_at: :desc))
    end
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StatementOfAccounts::SavingsAccountPdf.new(
          savings_account: @savings_account,
          view_context: view_context
        )
        send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Statement of Account.pdf'
        nil
      end
    end
  end
end
