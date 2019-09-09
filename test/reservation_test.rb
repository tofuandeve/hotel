require_relative 'test_helper'

describe Hotel::Reservation do
    before do
        @current_date = Date.today()
        @duration = 10
        @rate = 200.00
        
        @start_date = @current_date + 30
        @end_date = @start_date + @duration
        @date_range = Hotel::DateRange.new(@start_date, @end_date)
    end
    
    describe "Constructor" do
        it "can construct a reservation from date range" do
            reservation = Hotel::Reservation.new(date_range: @date_range, rate: @rate)
            expect (reservation).must_be_instance_of Hotel::Reservation
            expect (reservation.date_range).must_equal @date_range
        end
    end
    
    describe "Reservation class property" do
        it "doesn't charge checkout date for reservation's cost" do
            expected_cost = @duration * @rate
            
            reservation = Hotel::Reservation.new(date_range: @date_range, rate: @rate)
            expect (reservation.cost).must_equal expected_cost
        end
    end
end