require_relative 'test_helper'

describe Hotel::HotelSystem do
    before do
        @expected_number_of_rooms = 20
    end

    describe "Constructor" do
        it "can instantiate a HotelSystem object" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system).must_be_instance_of Hotel::HotelSystem
        end
        
        it "can instantiate a HotelSystem that tracks 20 rooms" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
        end
        
        it "allows user to access a list of Reservation" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system.reservations).must_be_instance_of Array
        end
    end
    
    describe "find_available_rooms method" do
        before do
            @hotel_system = Hotel::HotelSystem.new()
            @rooms = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
            @start_date1 = '2019-09-09'
            @end_date1 = '2019-09-15'
            @date1 = Hotel::DateRange.new(@start_date1, @end_date1)       
        end
        
        it "returns an array of available rooms" do
            available_rooms = @hotel_system.find_available_rooms(@date1)
            expect (available_rooms).must_be_instance_of Array
            expect (available_rooms).must_equal @rooms
            
            @hotel_system.make_reservation(@start_date1, @end_date1)
            expect (@hotel_system.find_available_rooms(@date1)).wont_equal @rooms     
        end
        
        it "returns an empty array if there is no rooms available" do
            @rooms.length.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
            end
            
            start_date2 = '2019-09-10'
            end_date2 = '2019-09-13'
            date2 = Hotel::DateRange.new(start_date2, end_date2)  
            
            available_rooms = @hotel_system.find_available_rooms(date2) 
            expect (available_rooms).must_be_empty
        end
    end
    
    describe "make reservation method" do
        before do
            @hotel_system = Hotel::HotelSystem.new()
            @start_date1 = '2019-09-10'
            @end_date1 = '2019-09-13'
            @number_of_reservations = 0
        end
        it "can update the list of reservations for valid date range" do
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
                expect (@hotel_system.reservations.length).must_equal @number_of_reservations + 1
                @number_of_reservations += 1
            end
            
            expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
            
            start_date2 = '2019-09-13'
            end_date2 = '2019-09-17'
            @hotel_system.make_reservation(start_date2, end_date2)
            expect (@hotel_system.reservations.length).must_equal @number_of_reservations + 1
        end
        
        it "won't modify number of rooms in hotel" do 
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
                expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
            end
        end
        
        it "does nothing if no rooms are available" do
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
            end
            @number_of_reservations = @expected_number_of_rooms
            
            expect (@hotel_system.reservations.length).must_equal @expected_number_of_rooms
            expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
            
            start_date2 = '2019-09-12'
            end_date2 = '2019-09-15'
            @hotel_system.make_reservation(start_date2, end_date2)
            expect (@hotel_system.reservations.length).must_equal @number_of_reservations
        end
        
        it "raises ArgumentError for invalid start and end dates" do
            invalid_dates = ['2019-09-33','2019-19-23','2000-09-01']
            
            invalid_dates.each do |invalid_date|
                expect {
                    @hotel_system.make_reservation(@start_date1, invalid_date)
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