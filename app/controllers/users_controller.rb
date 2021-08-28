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
    @user.password = Base64.encode64(user_params[:password]) if user_params[:password]

    if @user.save
      render_response_user(@user, 201)
    else
      render_response_user({ message: "User not created", errors: @user.errors.full_messages }, 400)
    end
  end

  def update
    if @user.update(user_params)
      @user.update(password: Base64.encode64(user_params[:password])) if user_params[:password]
      render_response_user(@user, 200)
    else
      render_response_user({ message: "User not updated", errors: @user.errors.full_messages }, 400)
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
