require 'rails_helper'

RSpec.describe Holiday do
  it 'exists' do
    holiday_data = {date: "2023-1-16", name: "MLK Day"}
    holiday_1 = Holiday.new(holiday_data)

    expect(holiday_1).to be_instance_of(Holiday)
  end
end
