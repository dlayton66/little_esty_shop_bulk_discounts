class BulkDiscountsController < ApplicationController
  before_action :find_merchant

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    @merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, bulk_discount)
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, bulk_discount)
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :discount, :quantity, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end