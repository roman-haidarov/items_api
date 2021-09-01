class UsersController < ApplicationController
  include UsersPolicy 

  before_action :authenticate!, only: [:index, :update, :show, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    return render_unauthorize unless can_read?(@current_user)
    @users = User.all

    render_response(@users, 200)
  end

  def show
    return render_unauthorize unless can_update?(@user, @current_user)

    render_response(@user, 200)
  end

  def create
    @user = User.new(user_params)
    @user.password = Base64.encode64(user_params[:password]) if user_params[:password]

    if @user.save
      render_response(@user, 201)
    else
      render_response({ message: "User not created", errors: @user.errors.full_messages }, 400)
    end
  end

  def update
    return render_unauthorize unless can_update?(@user, @current_user)
    
    if @user.update(user_params)
      @user.update(password: Base64.encode64(user_params[:password])) if user_params[:password]
      
      render_response(@user, 200)
    else
      render_response({ message: "User not updated", errors: @user.errors.full_messages }, 400)
    end
  end

  def destroy
    return render_unauthorize unless can_delete?(@current_user)

    @user.destroy

    render_response({ message: "User deleted" }, 204)
  end

  private

  def set_user
    @user = User.find_by!(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :name, :born_years)
  end
end
