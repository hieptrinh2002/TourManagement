class ErrorSerializer < ActiveModel::Serializer
  def self.serialize errors
    {
      status: false,
      errors: errors.full_messages
    }
  end
end
