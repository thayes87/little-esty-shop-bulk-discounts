class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @enabled_items = @merchant.enabled_items
    @disabled_items = @merchant.disabled_items
    @top_items = @merchant.items.order_by_revenue
  end

  def new
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])

    if params[:status].present?
      @item.update(status: params[:status])
      redirect_to merchant_items_path(@merchant)
    elsif @item.update(item_params)
      redirect_to merchant_item_path(@merchant, @item)
      flash[:notice] = "Item successfully updated."
    else
      flash[:notice] = "Item not updated, additional information required."
      render :show
    end
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.create(item_params)
    redirect_to merchant_items_path(@merchant)
  end

private
  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
