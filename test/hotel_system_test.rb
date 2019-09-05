require_relative 'test_helper'

describe Hotel::HotelSystem do
    describe "Constructor" do
        it "can instantiate a HotelSystem object" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system).must_be_instance_of Hotel::HotelSystem
        end
        
        it "can instantiate a HotelSystem that tracks 20 rooms" do
            expected_number_of_rooms = 20
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system.number_of_rooms).must_equal expected_number_of_rooms
        end
        
        it "allows user to access a list of Reservation" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system.reservations).must_be_instance_of Array
        end
    end
    
    describe "make reservation method" do
        it "can update the list of reservations for valid date range" do
            hotel_system = Hotel::HotelSystem.new()
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            number_of_reservations = hotel_system.reservations.length
            expected_number_of_rooms = hotel_system.number_of_rooms
            
            hotel_system.make_reservation(start_date, end_date)
            expect (
                hotel_system.reservations.length
            ).must_equal (number_of_reservations + 1)
            expect (hotel_system.number_of_rooms).must_equal expected_number_of_rooms
        end
        
        it "does nothing if no rooms are available" do
            hotel_system = Hotel::HotelSystem.new()
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            
            expected_number_of_rooms = hotel_system.number_of_rooms
            
            20.times do 
                hotel_system.make_reservation(start_date, end_date)
            end
            
            number_of_reservations = hotel_system.reservations.length
            expect (hotel_system.reservations.length).must_equal number_of_reservations
            expect (hotel_system.number_of_rooms).must_equal expected_number_of_rooms
            
            hotel_system.make_reservation(start_date, end_date)
            expect (hotel_system.reservations.length).must_equal number_of_reservations
        end
        
        it "raises ArgumentError for invalid start and end dates" do
            hotel_system = Hotel::HotelSystem.new()
            start_date = '2019-09-10'
            invalid_dates = ['2019-09-33','2019-19-23','2000-09-01']
            
            invalid_dates.each do |invalid_date|
                expect {
                    hotel_system.make_reservation(start_date, invalid_date)
                }.must_raise ArgumentError
            end
        end
    end
    
    describe "find reservation by date method" do
        before do 
            @hotel_system = Hotel::HotelSystem.new()
            start_dates = ['2019-09-10','2019-09-06','2019-09-07','2019-09-13']
            end_dates = ['2019-09-12','2019-09-14','2019-09-18','2019-09-22']
            
            start_dates.length.times do |index|
                @hotel_system.make_reservation(start_dates[index], end_dates[index])
            end
        end
        
        it "returns an array of reservations that has same date in their date ranges" do
            date = Date.parse('2019-09-10')
            reservations = @hotel_system.find_reservation_by_date(date)
            expect (reservations.length).must_equal 3
            reservations.each do |reservation|
                expect (
                    (reservation.date_range.start_date <= date) &&
                    (date < reservation.date_range.end_date)
                    ).must_equal true
            end
        end
        
        it "returns nil if there's no reservations found on that date" do
            date = Date.parse('2019-09-05')
            expect (@hotel_system.find_reservation_by_date(date)).must_be_empty	
        end
        
        it "ignore reservations that has same checkout dates as that date" do
            date1 = Date.parse('2019-09-22')
            expect (@hotel_system.find_reservation_by_date(date1)).must_be_empty
            
            date2 = Date.parse('2019-09-12')
            reservations = @hotel_system.find_reservation_by_date(date2)
            expect (reservations.length).must_equal 2
            reservations.each do |reservation|
                expect (
                    (reservation.date_range.start_date <= date2) && 
                    (date2 < reservation.date_range.end_date)
                ).must_equal true
            end
        end
    end
    
    describe "get reservation total cost method" do
        before do 
            @hotel_system = Hotel::HotelSystem.new()
            start_dates = ['2019-09-10','2019-09-06','2019-09-07','2019-09-13']
            end_dates = ['2019-09-12','2019-09-14','2019-09-18','2019-09-22']
            
            start_dates.length.times do |index|
                @hotel_system.make_reservation(start_dates[index], end_dates[index])
            end
            @reservations = @hotel_system.reservations
        end
        
        it "returns a float format with 2 decimal places for total cost" do
            reservation_id = @reservations.sample.id
            expect (
                @hotel_system.get_reservation_total_cost(reservation_id).to_s
            ).must_match (/\d+\.\d\d?/)
        end
        
        it "returns the total cost for a valid reservation" do
            @reservations.each do |reservation|
                expected_cost = reservation.cost
                reservation_id = reservation.id
                
                reservation_cost = @hotel_system.get_reservation_total_cost(reservation_id)
                expect (reservation_cost).must_equal expected_cost
            end
        end
        
        it "returns nil for a nonexistent reservation" do
            reservation_id = 12
            reservation = @hotel_system.get_reservation_total_cost(reservation_id)
            assert_nil (reservation)
        end
    end
end