class Api::V1::ToursController < Api::V1::ApplicationController
  before_action :authorized, except: %i(index show)
  before_action :set_tour, only: %i(show update destroy)

  # GET /api/v1/tours
  def index
    @tours = Tour.by_name(params[:name])
                 .by_status(params[:statuses])
                 .by_city(params[:city])

    render json: @tours, each_serializer: TourSerializer, status: :ok
  end

  # GET /api/v1/tours/:id
  def show
    render json: @tour, serializer: TourSerializer, status: :ok
  end

  # POST /api/v1/tours
  def create
    @tour = Tour.new(tour_params)

    if @tour.save
      render json: @tour, serializer: TourSerializer, status: :created
    else
      render json: ErrorSerializer.serialize(@tour.errors),
             status: :unprocessable_entity
    end
  end

  # PUT /api/v1/tours/:id
  def update
    if @tour.update(tour_params)
      render json: @tour, serializer: TourSerializer, status: :ok
    else
      render json: ErrorSerializer.serialize(@tour.errors),
             status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tours/:id
  def destroy
    if @tour.destroy
      render json: {
        status: true,
        message: I18n.t("api.tours.delete")
      }, status: :ok
    else
      render json: ErrorSerializer.serialize(@tour.errors),
             status: :unprocessable_entity
    end
  end

  private

  def set_tour
    @tour = Tour.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: false,
      message: I18n.t("api.tours.not_found")
    }, status: :not_found
  end

  def tour_params
    params.require(:tour).permit Tour::TOUR_ATTRIBUTES
  end
end
