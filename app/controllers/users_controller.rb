class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all

    render json: @users, status: 200
  end

  def show
    render json: @user, status: 200
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: 201
    else
      render json: { message: "User not created" }, status: 400
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 200
    else
      render json: { message: "User not updated" }, status: 400
    end
  end

  def destroy
    @user.destroy

    render json: { message: "User deleted" }, status: 204
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
