module SearchAPI
  class AmazonSearch
    @@URL = 'http://www.amazon.co.jp/s/ref=nb_sb_noss?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias%3Daps&field-keywords='
    @@UA  = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36'

    def initialize(keyword)
      @keyword = keyword
    end

    def word
      @keyword
    end

    def search(keyword = nil)
      @keyword  = keyword if keyword.present?
      targetURL = "#{@@URL}#{URI.escape(@keyword)}"
      doc       = nokogiri_object(targetURL)
      top_three = []
      prices    = []
      doc.css('#atfResults .prod').each do |node|
        url   = node.css('.image a')[0]['href']
        img   = node.css('.imageBox img')[0]['src']
        title = node.css('.newaps .bold')[0].text
        price = node.css('.newp .red')[0].text
        price.gsub!(/[^0-9]/,'')
        top_three << {url: url, img: img, price: price.to_i, title: title}
        prices << price.to_i
      end
      top_three[prices.each_with_index.min[1]]
    end


    private
    def nokogiri_object(url)
      charset = nil
      html = open(url, "User-Agent" => @@UA) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end
  end
end