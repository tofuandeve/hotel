require_relative 'test_helper'

describe Hotel::HotelBlock do
    describe "Constructor" do
        it "can create a HotelBlock object for valid input" do
            rooms = [2,3,4]
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            date = Hotel::DateRange.new(start_date, end_date)
            discount_rate = 0.2
            
            hotel_block = Hotel::HotelBlock.new(
                rooms: rooms, date_range: date, discount_rate: discount_rate
            )
            
            expect (hotel_block).must_be_instance_of Hotel::HotelBlock
        end
    end
end