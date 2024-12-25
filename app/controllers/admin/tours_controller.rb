class Admin::ToursController < Admin::AdminController
  include Admin::ToursHelper
  before_action :set_breadcrumbs
  before_action :set_tour, only: %i(show edit update remove_image)
  before_action :set_uploaded_images, only: %i(create update resize_before_save)
  before_action :resize_before_save, only: %i(create update)
  load_and_authorize_resource

  def index
    @q = Tour.ransack(params[:q])
    @tours = @q.result.by_status(params[:statuses]).order_by_status
    @pagy, @tours = pagy(@tours, items: Settings.digit_10)
  end

  def show
    add_breadcrumb(@tour.tour_name, admin_tours_path(@tour))
  end

  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new(tour_params)
    if @tour.save && check_image_limits(@tour, @uploaded_images)
      @tour.images.attach(@uploaded_images) if @uploaded_images.present?
      flash[:success] = t "flash.tour.create_success"
      redirect_to admin_tours_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb(@tour.tour_name, admin_tours_path(@tour))
    add_breadcrumb(t("edit"))
  end

  def update
    if can_edit_tour(@tour)
      if @tour.update(tour_params) &&
         check_image_limits(@tour, @uploaded_images)

        @tour.images.attach(@uploaded_images) if @uploaded_images.present?
        flash[:success] = t "flash.tour.update_success"
        redirect_to admin_tours_path, status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = t "flash.tour.invalid_update"
      render :edit, status: :unprocessable_entity
    end
  end

  def remove_image
    image = @tour.images.find(params[:image_id])
    image.purge
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("image_#{params[:image_id]}")
      end
    end
  end

  private

  def set_breadcrumbs
    add_breadcrumb(t("breadcrumb.home"), admin_path)
    add_breadcrumb(t("breadcrumb.tours"), admin_tours_path)
  end

  def check_image_limits record, images
    if total_image_count_exceeds_limit?(record.images.count, images,
                                        Settings.images_limit)
      @tour.errors.add(:images, I18n.t("errors.images_limit",
                                       limit: Settings.images_limit))
      return false
    end
    true
  end

  def set_tour
    @tour = Tour.find(params[:id])
    return if @tour

    redirect_to admin_tours_path, status: :see_other
    flash[:danger] = t "flash.tour.not_exist"
  end

  def set_uploaded_images
    @uploaded_images = filter_uploaded_images(params.dig(:tour, :images))
  end

  def tour_params
    params.require(:tour).permit Tour::TOUR_ATTRIBUTES
  end

  def resize_before_save
    return unless @uploaded_images

    @uploaded_images.each do |image|
      resize_result = resize_image(image,
                                   Settings.width_img_250,
                                   Settings.height_img_250)
      break unless resize_result
    end
  end

  def resize_image image_param, width, height
    return false unless image_param

    begin
      image = MiniMagick::Image.read(image_param)
      image.resize "#{width}x#{height}"
      image.write(image_param.tempfile.path)
      true
    rescue StandardError => _e
      flash.now[:danger] = I18n.t("flash.tour.invalid_image",
                                  image_name: image_param.original_filename)
      render :edit, status: :unprocessable_entity
      false
    end
  end

  def search_tours params
    Tour.by_name(params[:keyword])
        .or(Tour.by_city(params[:keyword]))
        .or(Tour.by_destination(params[:keyword]))
        .by_status(params[:status])
  end
end
