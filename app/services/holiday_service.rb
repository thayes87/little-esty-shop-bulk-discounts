require 'httparty'
require 'json'
require 'pry'

class HolidayService
  def self.get_holidays
    get_uri('https://date.nager.at/api/v3/NextPublicHolidays/US')
  end

  def self.get_uri(uri)
    response = HTTParty.get(uri)
    json_response = JSON.parse(response.body, symbolize_names: true)
  end
end