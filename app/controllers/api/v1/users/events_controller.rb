class API::V1::Users::EventsController < ApplicationController
  def index
    render json: set_user.events.all
  end

  def create
    if set_user.events << Event.create(event_params)
      head :ok
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private

  def set_user
    @user ||= User.find(params[:user_id])
  end

  def event_params
    params.permit(:start, :finish, :duration, :timezone, :name, :description, :location, :state, :user_id)
  end

end
