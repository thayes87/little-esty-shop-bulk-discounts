class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discounts = @merchant.bulk_discounts
    @holidays = HolidayFacade.all_holidays.sort_by(&:date).first(3)
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discount = @merchant.bulk_discounts.find(params[:id])
    if @merchant_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @merchant_discount)
      flash[:notice] = "Bulk Discount Successfully Updated"
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, @merchant_discount)
      flash[:notice] = "Bulk Discount NOT Successfully Updated, Additional Information Required"
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discount = @merchant.bulk_discounts.find(params[:id])
    @merchant_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

private
  def bulk_discount_params
    params.permit(:description, :quantity_break, :discount, :merchant_id)
  end
end