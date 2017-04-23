module Stocking
  # Fetch data from Yahoo
  module Yahoo
    module_function

    def default_url
      'https://finance.yahoo.com/quote/%s/financials'
    end

    def build_url(ticker)
      default_url % [ticker.upcase]
    end

    def ticker_cache
      @ticker_cache ||= {}
    end

    def fetch(ticker, url: build_url(ticker))
      ticker_cache[ticker] ||= begin
                                 $stderr.puts "starting browser: #{url}"
                                 browser = Watir::Browser.start(url)
                                 $stderr.puts 'getting TRs...'
                                 trs = browser.elements(:css, 'section > div > table > tbody > tr')
                                 $stderr.puts 'getting texts...'
                                 trs.map { |tr| tr.elements(:css, 'td').map(&:text) }.tap do
                                   $stderr.puts 'done'
                                 end
                               end
    end
  end
end
