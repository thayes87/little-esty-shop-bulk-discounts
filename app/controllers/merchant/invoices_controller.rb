class Merchant::InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.all.uniq
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @invoice_items = @invoice.invoice_items
    @bulk_discount_revenue = @invoice.collect_item_information(@merchant)
  end
  

  # def update
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @invoice = Invoice.find(params[:id])
  #   @invoice_items = @invoice.invoice_items
  #   item = InvoiceItem.find_by(item_id: params[:item_id], invoice_id: params[:id])
  #   item.update(invoice_item_params)
  #   redirect_to merchant_invoice_path(@merchant, @invoice)
  # end
  
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    invoice_item = InvoiceItem.find(params[:invoice_item_id])
    invoice_item.update(invoice_item_params)
    redirect_to merchant_invoice_path(@merchant, @invoice)
  end

  private
  def invoice_item_params
    params.permit(:invoice_id, :item_id, :quantity, :unit_price, :status)
  end
end
