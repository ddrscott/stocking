require 'net/http'
require 'uri'
require 'csv'

module Stocking
  module YahooQuotes
    module_function

    def fetch(tickers, url: default_url, fields: default_fields)
      # ensure it's an array
      tickers = Array(tickers).join
      data = Net::HTTP.get(URI.parse(url % { tickers: tickers, fields: fields.join }))
      columns = fields.map { |f| ALL[f] }
      CSV.generate_line(columns) + data
    end

    def default_url
      'http://download.finance.yahoo.com/d/quotes.csv?s=%{tickers}&f=%{fields}'
    end

    def default_fields
      ALL.keys
    end

    # Pricing
    PRICING = {
      'a'  => 'Ask',
      'b'  => 'Bid',
      'b2' => 'Ask (Realtime)',
      'b3' => 'Bid (Realtime)',
      'p'  => 'Previous Close',
      'o'  => 'Open'
    }

    # Dividends
    DIVIDENDS = {
      'y'  => 'Dividend Yield',
      'd'  => 'Dividend per Share',
      'r1' => 'Dividend Pay Date',
      'q'  => 'Ex-Dividend Date'
    }

    # Averages
    AVERAGES = {
      'c8' => 'After Hours Change (Realtime)',
      'c3' => 'Commission',
      'g'  => "Day's Low",
      'h'  => "Day's High",
      'k1' => 'Last Trade (Realtime) With Time',
      'l'  => 'Last Trade (With Time)',
      'l1' => 'Last Trade (Price Only)',
      't8' => '1 yr Target Price',
      'm5' => 'Change From 200 Day Moving Average',
      'm6' => 'Percent Change From 200 Day Moving Average',
      'm7' => 'Change From 50 Day Moving Average',
      'm8' => 'Percent Change From 50 Day Moving Average',
      'm3' => '50 Day Moving Average',
      'm4' => '200 Day Moving Average'
    }

    # 52 Week Pricing
    WEEK_PRICING = {
      'k'  => '52 Week High',
      'j'  => '52 week Low',
      'j5' => 'Change From 52 Week Low',
      'k4' => 'Change From 52 week High',
      'j6' => 'Percent Change From 52 week Low',
      'k5' => 'Percent Change From 52 week High',
      'w'  => '52 week Range'
    }

    # Volume
    VOLUME = {
      'v'  => 'Volume',
      'a5' => 'Ask Size',
      'b6' => 'Bid Size',
      'k3' => 'Last Trade Size',
      'a2' => 'Average Daily Volume'
    }

    # Ratios
    RATIOS = {
      'e'  => 'Earnings per Share',
      'e7' => 'EPS Estimate Current Year',
      'e8' => 'EPS Estimate Next Year',
      'e9' => 'EPS Estimate Next Quarter',
      'b4' => 'Book Value',
      'j4' => 'EBITDA',
      'p5' => 'Price / Sales',
      'p6' => 'Price / Book',
      'r'  => 'P/E Ratio',
      'r2' => 'P/E Ratio (Realtime)',
      'r5' => 'PEG Ratio',
      'r6' => 'Price / EPS Estimate Current Year',
      'r7' => 'Price / EPS Estimate Next Year',
      's7' => 'Short Ratio'
    }

    # Misc
    MISC = {
      't7' => 'Ticker Trend',
      't6' => 'Trade Links',
      'i5' => 'Order Book (Realtime)',
      'l2' => 'High Limit',
      'l3' => 'Low Limit',
      'v1' => 'Holdings Value',
      'v7' => 'Holdings Value (Realtime)',
      's6' => 'Revenue',
      'w1' => "Day's Value Change",
      'w4' => "Day's Value Change (Realtime)",
      'p1' => 'Price Paid',
      'm'  => "Day's Range",
      'm2' => "Day's Range (Realtime)",
      'g1' => 'Holdings Gain Percent',
      'g3' => 'Annualized Gain',
      'g4' => 'Holdings Gain',
      'g5' => 'Holdings Gain Percent (Realtime)',
      'g6' => 'Holdings Gain (Realtime)'
    }

    # Symbol Info
    SYMBOL = {
      'i' => 'More Info',
      'j1' => 'Market Capitalization',
      'j3' => 'Market Cap (Realtime)',
      'f6' => 'Float Shares',
      'n' => 'Name',
      'n4' => 'Notes',
      's' => 'Symbol',
      's1' => 'Shares Owned',
      'x' => 'Stock Exchange',
      'j2' => 'Shares Outstanding'
    }

    # Date
    DATE = {
      'c1' => 'Change',
      'c' => 'Change & Percent Change',
      'c6' => 'Change (Realtime)',
      'k2' => 'Change Percent (Realtime)',
      'p2' => 'Change in Percent',
      'd1' => 'Last Trade Date',
      'd2' => 'Trade Date',
      't1' => 'Last Trade Time'
    }

    ALL = [
      PRICING,
      DIVIDENDS,
      AVERAGES,
      WEEK_PRICING,
      VOLUME,
      RATIOS,
      MISC,
      SYMBOL,
      DATE
    ].each_with_object({}) { |item, acc| acc.merge!(item) }
  end
end
