class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items.all
  end

  def show
    @item = Item.find(params[:id])
  end
end
