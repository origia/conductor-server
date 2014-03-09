module SearchAPI
  class YahooSearch
    @@URL = 'http://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch?appid=dj0zaiZpPWczOUc4bG5MYU1ldiZzPWNvbnN1bWVyc2VjcmV0Jng9NzQ-&sort=%2Bprice&query='

    def initialize(keyword)
      @keyword = keyword
    end

    def word
      @keyword
    end

    def search(keyword = nil)
      @keyword = keyword if keyword.present?

      charset = nil
      html = open("#{@@URL}#{URI.escape(@keyword)}") do |f|
        charset = f.charset
        f.read
      end
      results = JSON.parse(html)['ResultSet']['0']['Result']
      top    = []
      prices = []
      keys   = results.keys.select{|key|  key if key=~ /[0-9]+/}
      keys.each do |key|
        result = results[key]
        title  = result['Name']
        img    = result['Image']['Medium']
        url    = result['Url']
        price  = result['Price']['_value'].to_i
        top << {url: url, img: img, price: price, title: title}
        prices << price
      end
      top[prices.each_with_index.min[1]]
    end
  end
end