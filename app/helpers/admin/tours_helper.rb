module Admin::ToursHelper
  def filter_uploaded_images images
    images.select{|item| item.is_a?(ActionDispatch::Http::UploadedFile)}
  end

  def total_image_count_exceeds_limit? current_count, new_images, limit
    current_count + new_images.count > limit
  end
end
