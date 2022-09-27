require 'httparty'
require 'json'
require 'pry'

class HolidayService
  def self.get_holidays
    get_uri('https://date.nager.at/api/v3/NextPublicHolidays/%22us%22')
  end

  def self.get_uri(uri)
    resonse = HTTParty.get(uri)
    JSON.parse(response.body, symbolize_names: true)
  end
end