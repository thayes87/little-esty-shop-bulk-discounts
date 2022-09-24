class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
      flash[:notice] = "Discount Successfully Created!"
    else  
      redirect_to new_merchant_bulk_discount_path(@merchant)
      flash[:notice] = "Discount Not Created, Additional Information Required."
    end
  end

private
  def bulk_discount_params
    params.permit(:description, :quantity_break, :discount, :merchant_id)
  end
end