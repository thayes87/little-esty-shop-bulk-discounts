class Merchant::InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoice_ids = @merchant.invoices.pluck(:id).uniq
  end
end
