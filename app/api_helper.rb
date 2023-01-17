require 'httparty'
require 'json'

class ApiHelper
  def initialize
    @data = get_parsed_data("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end

  def get_parsed_data(url)
    parse(get_data(url))
  end
  
  def get_data(url)
    HTTParty.get(url)
  end
  
  def parse(data)
    JSON.parse(data.body, symbolize_names: true)
  end

  def next_three_holidays
    @data.pluck(:localName)[0..2]
  end
end