class Admin::VouchersController < Admin::AdminController
  before_action :voucher, only: %i(edit update destroy show)
  before_action :set_breadcrumbs
  load_and_authorize_resource

  def index
    @pagy, @vouchers = pagy(Voucher.by_status(params[:status])
                            .by_code(params[:code])
                            .by_percent_discount(params[:percent_discount])
                            .by_min_total_price(params[:min_total_price]),
                            items: Settings.voucher.items_per_page)
  end

  def new
    @voucher = Voucher.new
  end

  def show
    add_breadcrumb(@voucher.code)
  end

  def create
    @voucher = Voucher.new(voucher_params)
    if @voucher.save
      flash[:success] = t "flash.voucher.create_success"
      redirect_to admin_vouchers_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @voucher.is_used
      flash[:danger] = t "flash.voucher.is_used"
    elsif @voucher.update(voucher_params)
      flash[:success] = t "flash.voucher.edit_success"
      redirect_to admin_vouchers_path, status: :see_other
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    if @voucher.is_used
      flash[:danger] = t "flash.voucher.is_used"
    elsif @voucher.update(voucher_params)
      flash[:success] = t "flash.voucher.delete_success"
    else
      flash[:danger] = t "flash.voucher.delete_failed"
    end
    redirect_to admin_vouchers_path
  end

  private

  def set_breadcrumbs
    add_breadcrumb(t("breadcrumb.home"), admin_path)
    add_breadcrumb(t("breadcrumb.vouchers"), admin_vouchers_path)
  end

  def voucher
    @voucher = Voucher.find_by(id: params[:id])
    return if @voucher.present?

    flash[:danger] = t "flash.voucher.find_voucher_failed"
    redirect_to admin_vouchers_path
  end

  def voucher_params
    params.require(:voucher).permit Voucher::VOUCHER_ATTRIBUTES
  end
end
