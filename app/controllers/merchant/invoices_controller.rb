class Merchant::InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.all.uniq
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @invoice_items = @invoice.invoice_items

    
      
    if @merchant.bulk_discounts.count == 1 && @invoice_items.where("quantity >= ?", @merchant.bulk_discounts.first.quantity_break).present?
      discounted_items = @invoice_items.where("quantity >= ?", @merchant.bulk_discounts.first.quantity_break)
      non_discounted_items = @invoice_items.where("quantity < ?", @merchant.bulk_discounts.first.quantity_break)

      discount_revenue = discounted_items.sum('quantity * unit_price') * (1 - (@merchant.bulk_discounts.first.discount.to_f / 100))
      non_discounted_revenue = non_discounted_items.sum('quantity * unit_price').to_f

      @bulk_discount_revenue = discount_revenue + non_discounted_revenue
    else 
      @bulk_discount_revenue = @invoice.total_revenue
    end
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
