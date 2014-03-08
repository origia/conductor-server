class Search
  include Mongoid::Document
  include Mongoid::Timestamps

  field :word, type: String
  field :object, type: String
  field :img, type: String

  def created_at_s
    self.created_at.strftime '%m/%d %H:%M'
  end

end