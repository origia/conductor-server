module SearchAPI
  class RakutenSearch


    def initialize(keyword)
      RakutenWebService.configuration do |c|
        c.application_id = '1046311902966142326'
        c.affiliate_id   = '1270edbf.db4fc306.1270edc0.faa2f822'
      end
      @keyword = keyword
    end

    def word
      @keyword
    end

    def search(keyword = nil)
      @keyword = keyword if keyword.present?
      items = RakutenWebService::Ichiba::Item.search(keyword: @keyword, sort: '+itemPrice')

      min_price_item = items.find do |item|
        item['itemPrice'].to_i > 10
      end
      {url: min_price_item['itemUrl'], img: min_price_item['mediumImageUrls'][0]['imageUrl'], price: min_price_item['itemPrice'].to_i, title: min_price_item['itemName']}
    end

  end
end