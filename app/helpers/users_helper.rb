module UsersHelper
  def gravatar_for user, size
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    name = user.first_name + " " + user.last_name
    image_tag gravatar_url, alt: name, class: "gravatar"
  end
end
