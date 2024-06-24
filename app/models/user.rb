class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  ATTRIBUTES = %i(
    first_name
    last_name
    email
    password
    password_confirmation
  ).freeze

  enum role: {customer: 0, admin: 1}
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :first_name, presence: true,
            length: {maximum: Settings.user.max_len_first_name}
  validates :last_name, presence: true,
            length: {maximum: Settings.user.max_len_last_name}

  before_save :downcase_email
  validates :email, presence: true,
                    length: {minimum: Settings.user.min_len_email,
                             maximum: Settings.user.max_len_email},
                    format: {with: Regexp.new(Settings.VALID_EMAIL_REGEX)},
                    uniqueness: {case_sensitive: false}

  validates :address, length: {maximum: Settings.user.max_len_address}

  validates :password, presence: true,
                       length: {minimum: Settings.user.min_len_password},
                       if: :password

  private
  def downcase_email
    email.downcase!
  end
end
