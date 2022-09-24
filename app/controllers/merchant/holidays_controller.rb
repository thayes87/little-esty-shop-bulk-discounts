class HolidayController < ApplicationController
  def index
    @holidays = HolidayFacade.all_holidays
  end
end