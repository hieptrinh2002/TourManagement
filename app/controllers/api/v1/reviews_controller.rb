class Api::V1::ReviewsController < Api::V1::ApplicationController
  before_action :authorized, except: %i(index show)
  before_action :find_review, only: %i(show update destroy)

  # GET /api/v1/reviews
  def index
    items_per_page = params[:items_per_page].to_i
    @pagy, @reviews = pagy(Review.sorted_by_rating.sorted_by_created_at,
                           items: items_per_page)

    render json: @reviews, each_serializer: ReviewSerializer, status: :ok
  end

  # GET /api/v1/reviews/:id
  def show
    render json: @review, serializer: ReviewSerializer, status: :ok
  end

  # POST /api/v1/reviews
  def create
    @review = Review.new(review_params)

    if @review.save
      render json: @review, serializer: ReviewSerializer,
             status: :created
    else
      render json: ErrorSerializer.serialize(@review.errors),
             status: :unprocessable_entity
    end
  end

  # PUT /api/v1/reviews/:id
  def update
    if @review.update(review_params)
      render json: @review, serializer: ReviewSerializer, status: :ok
    else
      render json: ErrorSerializer.serialize(@review.errors),
             status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/reviews/:id
  def destroy
    if @review.destroy
      render json: {status: true, message: I18n.t("api.reviews.delete")},
             status: :ok
    else
      render json: ErrorSerializer.serialize(@review.errors),
             status: :unprocessable_entity
    end
  end

  private

  def find_review
    @review = Review.find_by(id: params[:id])
    return unless @review.nil?

    render json: {status: false, message: I18n.t("api.reviews.not_found")},
           status: :not_found
  end

  def review_params
    params.require(:review).permit Review::REVIEW_ATTRIBUTES
  end
end
