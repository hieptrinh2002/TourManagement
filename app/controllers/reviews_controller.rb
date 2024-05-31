class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour, only: %i(create update destroy)
  before_action :set_review, only: %i(update destroy)
  def new; end

  def edit; end

  def create
    @review = Review.new(review_params)
    if booking_exists_for_user_and_tour?
      if @review.save
        redirect_to tour_path(@tour)
      else
        flash[:danger] = t("flash.review.create_failed")
        redirect_to tours_path, status: :unprocessable_entity
      end
    else
      flash[:danger] = t("flash.review.review_denied")
      redirect_to tours_path, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      redirect_to tour_path(@tour)
    else
      flash[:danger] = t "flash.review.update_failed"
      redirect_to tours_path, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.destroy
      redirect_to tour_path(@tour)
    else
      flash[:danger] = t "flash.review.destroy_failed"
      redirect_to tours_path, status: :unprocessable_entity
    end
  end

  private
  def review_params
    params.require(:review).permit Review::REVIEW_ATTRIBUTES
  end

  def set_review
    @review = Review.find_by(id: params[:id])
    return if @review.present?

    flash[:danger] = t "flash.review.not_found"
    redirect_to tours_path
  end

  def set_tour
    @tour = Tour.find_by(id: params[:tour_id])
    return if @tour.present?

    flash[:danger] = t "flash.tour.find_tour_failed"
    redirect_to tours_path
  end

  def booking_exists_for_user_and_tour?
    Booking.for_tour(@tour.id)
           .belongs_to_user(current_user.id).present?
  end
end
