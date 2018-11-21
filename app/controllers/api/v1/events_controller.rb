class API::V1::EventsController < ApplicationController
  def index
    render json: Event.all
  end

  def show
    render json: set_event, serializer: Event::ShowSerializer
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event, serializer: Event::ShowSerializer, status: 201
    else
      render json: { errors: event.try(:errors) }, status: 422
    end
  end

  def update
    event = set_event
    if event.update(event_params)
      render json: event, serializer: Event::ShowSerializer, status: 200
    else
      render json: { errors: event.try(:errors) }, status: 422
    end
  end

  def destroy
    event = set_event
    if event.destroy
      head 204
    else
      render json: { errors: event.try(:errors) }, status: 422
    end
  end

  def publish
    event = set_event
    if event.publish!
      render json: event, serializer: Event::ShowSerializer, status: 200
    end
  rescue Event::AASM::InvalidTransition => e
    render json: {
      error: e.to_s
    }, status: :error
  end

  private

  def set_event
    @event ||= Event.find params[:id]
  end

  def event_params
    params.permit(:id, :start, :finish, :duration, :timezone, :name, :description, :location, :state, :user_id)
  end
end
