require_relative 'test_helper'

describe Hotel::HotelBlock do
    describe "Constructor" do
        it "can create a HotelBlock object for valid input" do
            rooms = [2,3,4]
            current_date = Date.today()
            duration = 10
            
            start_date = current_date + 30
            end_date = start_date + duration
            date_range = Hotel::DateRange.new(start_date, end_date)
            discount_rate = 0.2
            
            hotel_block = Hotel::HotelBlock.new(
                rooms: rooms, date_range: date_range, discount_rate: discount_rate
            )
            
            expect (hotel_block).must_be_instance_of Hotel::HotelBlock
        end
    end
end