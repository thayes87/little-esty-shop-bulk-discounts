class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items.all
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
    if @item.update(item_params)
      redirect_to merchant_item_path(@merchant, @item)
      flash[:notice] = "Item successfully updated."
    else 
      flash[:notice] = "Item not updated, additional information required."
      render :show
    end
  end

private
  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
