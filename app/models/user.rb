class User
  include Mongoid::Document
  before_create :set_token

  field :location, type: Array
  field :token, type: String
  field :device_token, type: String

  index({ location: "2d" }, { min: -200, max: 200 })
  index({ token: 1 }, { unique: true, name: "token_index" })

  has_many :bumps

  def update_position(data)
    return false unless data.has_key?('latitude') && data.has_key?('longitude')
    self.location = [data['longitude'], data['latitude']]
    self.save
  end

  def notify_nearby
    to_notify = User.near(location: self.location)
                    .max_distance(location: 10)
    to_notify.each do |u|
      PushManager.push(u.device_token, { position: 4 }) # TODO: give real position
    end
  end

  protected
  def set_token
    self.token = loop do
      token = SecureRandom.urlsafe_base64
      break token unless User.where(token: token).exists?
    end
  end
end
