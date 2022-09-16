class DashboardsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = Item.ready_to_ship(params[:merchant_id])
  end
end
