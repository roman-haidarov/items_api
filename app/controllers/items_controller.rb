class ItemsController < ApplicationController
  include ItemsPolicy

  before_action :set_item, only: [:show, :update, :destroy]
  before_action :set_user, only: [:index, :create]
  before_action :authenticate!, only: [:create, :update, :destroy]
  
  def index
    # can read all
    @items = @user.items

    render_response(@items, 200)
  end

  def show
    # can read all
    render_response(@item, 200)
  end

  def create
    # can create user, admin
    @item = @user.items.new(item_params)

    if @item.save
      render_response(@item, 201)
    else
      render_response({ message: "Record not created", errors: @item.errors.full_messages }, 400)
    end
  end

  def update  
    return render_unauthorize unless can_write?(@item, @current_user)
    
    if @item.update(item_params)
      render_response(@item, 200)
    else
      render_response({ message: "Record not updated", errors: @item.errors.full_messages }, 400)
    end
  end

  def destroy
    return render_unauthorize unless can_write?(@item, @current_user)
    
    @item.destroy

    render_response("Record deleted", 204)
  end

  private

  def item_params
    params.require(:item).permit(:name, :price)
  end

  def set_item
    set_user
    @item = @user.items.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def render_response(value, status)
    render json: value, status: status
  end
end

