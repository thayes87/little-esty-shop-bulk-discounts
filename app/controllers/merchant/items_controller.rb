class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @enabled_items = @merchant.enabled_items
    @disabled_items = @merchant.disabled_items
    @top_items = @merchant.items.order_by_revenue
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
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
      redirect_to edit_merchant_item_path(@merchant, @item)
      flash[:notice] = "Item not updated, additional information required."
    end
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new(item_params)
    if @item.save
      redirect_to merchant_items_path(@merchant)
      flash[:notice] = "Item successfully created!"
    else
      redirect_to new_merchant_item_path(@merchant)
      flash[:notice] = "Item not created: Additional information required."
    end
  end

private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
