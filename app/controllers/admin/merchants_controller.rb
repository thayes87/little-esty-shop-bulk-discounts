class Admin::MerchantsController < ApplicationController
  def index
    @enabled_merchants = Merchant.enabled_merchants
    @disabled_merchants = Merchant.disabled_merchants
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      redirect_to admin_merchants_path
    else
      flash.now[:error] = 'Merchant not created: Missing required information'
      render new_admin_merchant_path
    end
  end

  def update
    merchant = Merchant.find(params[:id])

    if params[:status].present?
      merchant.update(status: params[:status])
      redirect_to admin_merchants_path, notice: "Updated Status Successfully"
    elsif merchant.update(merchant_params)
      redirect_to admin_merchant_path(params[:id]), notice: "Updated Successfully"
    else
      flash[:notice] = "Merchant not updated, additional information required."
      render :show
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
