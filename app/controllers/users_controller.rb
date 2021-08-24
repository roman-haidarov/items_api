class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all

    render_response_user(@users, 200)
  end

  def show
    render_response_user(@user, 200)
  end

  def create

    @user = User.new(user_params)

    if @user.save
      render_response_user(@user, 201)
    else
      render_response_user({ message: "User not created" }, 400)
    end
  end

  def update
    # can update user, admin
    if @user.update(user_params)
      render_response_user(@user, 200)
    else
      render_response_user({ message: "User not updated" }, 400)
    end
  end

  def destroy
    # can destroy admin
    @user.destroy

    render_response_user({ message: "User deleted" }, 204)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :name, :born_years)
  end

  def render_response_user(value, status)
    render json: value, status: status
  end
end
