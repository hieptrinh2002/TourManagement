module BookingsHelper
  def time_difference_in_hours_and_minutes(datetime1, datetime2)
    # Tính toán sự chênh lệch thời gian bằng giây
    time_difference_in_seconds = (datetime1 - datetime2).abs

    # Chuyển đổi sang phút
    total_minutes = (time_difference_in_seconds / 60).to_i

    # Tính số giờ và số phút
    hours = total_minutes / 60
    minutes = total_minutes % 60

    # Định dạng chuỗi kết quả
    "#{hours}h #{minutes}p"
  end
end
