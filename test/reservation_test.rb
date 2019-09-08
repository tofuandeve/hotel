require_relative 'test_helper'

describe Hotel::Reservation do
    describe "Constructor" do
        it "can construct a reservation from date range" do
            start_date = '2020-09-10'
            end_date = '2020-09-13'
            date_range = Hotel::DateRange.new(start_date, end_date)
            rate = 200.00

            reservation = Hotel::Reservation.new(date_range: date_range, rate: rate)
            expect (reservation).must_be_instance_of Hotel::Reservation
            expect (reservation.date_range).must_equal date_range
        end
    end
    
    describe "Reservation class property" do
        it "doesn't charge checkout date for reservation's cost" do
            start_date = '2020-09-10'
            end_date = '2020-09-13'
            date_range = Hotel::DateRange.new(start_date, end_date)
            rate = 200.00
            stay_duration = 3
            expected_cost = stay_duration * rate
            
            reservation = Hotel::Reservation.new(date_range: date_range, rate: rate)
            expect (reservation.cost).must_equal expected_cost
        end
    end
end