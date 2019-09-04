require_relative 'test_helper'

describe Hotel::Reservation do
    describe "Constructor" do
        it "can construct a reservation from date range" do
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            date_range = Hotel::DateRange.new(start_date, end_date)
            rate = 200.00
            id = 1000

            reservation = Hotel::Reservation.new(date_range, rate, id)
            expect (reservation).must_be_instance_of Hotel::Reservation
        end
    end
end