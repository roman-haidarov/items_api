class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    @items = Item.all

    render_response(@items, 200)
  end

  def show
    render_response(@item, 200)
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render_response(@item, 201)
    else
      render_response({ message: "Record not created", errors: @item.errors.full_messages }, 400)
    end
  end

  def update
    if @item.update(item_params)
      render_response(@item, 200)
    else
      render_response({ message: "Record not updated", errors: @item.errors.full_messages }, 400)
    end
  end

  def destroy
    @item.destroy

    render_response("Record deleted", 204)
  end

  private

  def item_params
    params.require(:item).permit(:name, :price)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def render_response(value, status)
    render json: value, status: status
  end
end

