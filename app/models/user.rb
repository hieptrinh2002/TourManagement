class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :lockable,
         :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

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

  validates :password, presence: true,
                       length: {minimum: Settings.user.min_len_password},
                       if: :password

  scope :customer_created_by_month, (lambda do
    where(role: :customer).group_by_month(:created_at).count
  end)

  def send_devise_notification(notification, *args)
    DeviseMailerJob.perform_now devise_mailer, notification, id, *args
  end

  def self.from_google user
    create_with(uid: user[:uid], provider: Settings.google,
                first_name: user[:first_name],
                last_name: user[:last_name],
                password: Devise.friendly_token[0, 20])
      .find_or_create_by!(email: user[:email])
  end

  private
  def downcase_email
    email.downcase!
  end

  def password_required?
    true
  end
end
