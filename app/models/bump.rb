class Bump
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :position, type: Integer
  field :location, type: Array

  def created_at_s
    self.created_at.strftime '%m/%d %H:%M'
  end

  def position_s
    (self.position & 0x04 == 0) ? 'left' : 'right'
  end

  def location_s
    return '' unless (!self.location.nil? && self.location.length == 2)
    sprintf("%0.6f, %0.6f", self.location[0], self.location[1])
  end
end
