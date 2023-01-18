require './app/api_helper'

class BulkDiscountsController < ApplicationController
  before_action :find_merchant
  before_action :find_bulk_discount, only: [:show, :edit, :destroy, :update]

  def index
    @bulk_discounts = @merchant.bulk_discounts
    @api_helper = ApiHelper.new
  end

  def show
  end

  def new
    if(params[:name])
      @bulk_discount = BulkDiscount.new(name: params[:name],
                                        discount: 30,
                                        quantity: 2)
    else
      @bulk_discount = BulkDiscount.new
    end
  end

  def create
    @merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  
    def bulk_discount_params
      params.require(:bulk_discount).permit(:name, :discount, :quantity, :merchant_id)
    end

    def find_merchant
      @merchant = Merchant.find(params[:merchant_id])
    end

    def find_bulk_discount
      @bulk_discount = BulkDiscount.find(params[:id])
    end
end