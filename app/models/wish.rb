class Wish
  include Mongoid::Document
  include Mongoid::Timestamps

  field :word, type: String
  field :amazon, type: Hash
  field :yahoo, type: Hash
  field :rakuten, type: Hash
  field :title, type: String
  field :currentTime, type: String

  def created_at_s
    self.created_at.strftime '%m/%d %H:%M'
  end

  class << self
    def search_and_create(params)
      wish             = self.new
      wish.word        = params[:word]
      wish.title       = params[:title]
      wish.currentTime = params[:currentTime]
      wish.save

      search_obj = {}

      search_obj['rakuten'] = SearchAPI::RakutenSearch.new(wish.word)
      search_obj['amazon']  = SearchAPI::AmazonSearch.new(wish.word)
      search_obj['yahoo']   = SearchAPI::YahooSearch.new(wish.word)

      Parallel.each(search_obj, in_threads: 3) {|key, obj|
        results = obj.search
        w = self.where(word: obj.word).first
        w[key] = results
        w.save
      }
      self.where(_id: wish[:_id])
    end
  end

end