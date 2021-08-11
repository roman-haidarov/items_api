class ItemsController < ApplicationController
  def index
    @items = Item.all

    render json: @items, status: 200
  end

  def show
    @item = Item.find(params[:id])

    render json: @item, status: 200
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: 201
    else
      render json: { message: "Record not created", errors: @item.errors.full_messages }, status: 400
    end
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      render json: @item, status: 200
    else
      render json: { message: "Record not updated", errors: @item.errors.full_messages }, status: 400
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    render json: "Record deleted", status: 204
  end

  private

  def item_params
    params.require(:item).permit(:name, :price)
  end
end

