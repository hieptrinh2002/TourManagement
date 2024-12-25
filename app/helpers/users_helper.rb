module UsersHelper
  def gravatar_for user, size
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.first_name,
              class: "gravatar rounded-circle shadow-1-strong me-3",
              height: size, width: size
  end
end
