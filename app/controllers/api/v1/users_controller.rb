class API::V1::UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    render json: set_user, serializer: User::ShowSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, serializer: User::ShowSerializer, status: 201
    else
      render json: { errors: user.try(:errors) }, status: 422
    end
  end

  private

  def set_user
    @user ||= User.find params[:id]
  end

  def user_params
    params.permit(:username)
  end
end
