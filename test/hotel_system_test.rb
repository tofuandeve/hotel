require_relative 'test_helper'

describe Hotel::HotelSystem do
    before do
        @expected_number_of_rooms = 20
        @hotel_system = Hotel::HotelSystem.new()
    end
    
    describe "Constructor" do
        it "can instantiate a HotelSystem object" do
            expect (@hotel_system).must_be_instance_of Hotel::HotelSystem
        end
        
        it "can instantiate a HotelSystem that tracks 20 rooms" do
            expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
        end
        
        it "allows user to access a list of Reservation" do
            expect (@hotel_system.reservations).must_be_instance_of Array
        end
    end
    
    describe "find_available_rooms method" do
        before do
            @rooms = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
            @start_date1 = '2020-01-09'
            @end_date1 = '2020-01-15'
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
            
            start_date2 = '2020-01-10'
            end_date2 = '2020-01-13'
            date2 = Hotel::DateRange.new(start_date2, end_date2)  
            
            available_rooms = @hotel_system.find_available_rooms(date2) 
            expect (available_rooms).must_be_empty
        end
    end
    
    describe "make reservation method" do
        before do
            @start_date1 = '2020-01-10'
            @end_date1 = '2020-01-13'
            @number_of_reservations = 0
        end
        
        it "can update the list of reservations for valid date range" do
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
                expect (@hotel_system.reservations.length).must_equal @number_of_reservations + 1
                @number_of_reservations += 1
            end
            
            expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
            
            start_date2 = '2020-01-13'
            end_date2 = '2020-01-17'
            @hotel_system.make_reservation(start_date2, end_date2)
            expect (@hotel_system.reservations.length).must_equal @number_of_reservations + 1
        end
        
        it "won't modify number of rooms in hotel" do 
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
                expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
            end
        end
        
        it "raises ArgumentError if no rooms are available" do
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
            end
            @number_of_reservations = @expected_number_of_rooms
            
            expect (@hotel_system.reservations.length).must_equal @expected_number_of_rooms
            expect (@hotel_system.number_of_rooms).must_equal @expected_number_of_rooms
            
            start_date2 = '2020-01-12'
            end_date2 = '2020-01-15'
            expect {@hotel_system.make_reservation(start_date2, end_date2)}.must_raise ArgumentError
        end
        
        it "raises ArgumentError for invalid start and end dates" do
            invalid_dates = ['2020-01-33','2019-19-23','2000-09-01']
            
            invalid_dates.each do |invalid_date|
                expect {
                    @hotel_system.make_reservation(@start_date1, invalid_date)
                }.must_raise ArgumentError
            end
        end
        
        it "raise ArgumentError if user tries to book a room has been set aside for an overlapping date range" do
            17.times do 
                @hotel_system.make_reservation(@start_date1, @end_date1)
                @number_of_reservations += 1
            end
            
            rooms = [18, 19, 20]
            start_date = '2020-01-10'
            end_date = '2020-01-23'
            
            date_range = Hotel::DateRange.new(start_date, end_date)
            @hotel_system.create_hotel_block(rooms: rooms, date_range: date_range)
            
            
            start_date2 = '2020-01-12'
            end_date2 = '2020-01-15'
            expect {@hotel_system.make_reservation(start_date2, end_date2)}.must_raise ArgumentError
        end
    end
    
    describe "find reservation by date method" do
        before do 
            start_dates = ['2020-01-10','2020-01-06','2020-01-07','2020-01-13']
            end_dates = ['2020-01-12','2020-01-14','2020-01-18','2020-01-22']
            
            start_dates.length.times do |index|
                @hotel_system.make_reservation(start_dates[index], end_dates[index])
            end
        end
        
        it "returns an array of reservations that has same date in their date ranges" do
            date = Date.parse('2020-01-10')
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
            date = Date.parse('2020-01-05')
            expect (@hotel_system.find_reservation_by_date(date)).must_be_empty	
        end
        
        it "ignore reservations that has same checkout dates as that date" do
            date1 = Date.parse('2020-01-22')
            expect (@hotel_system.find_reservation_by_date(date1)).must_be_empty
            
            date2 = Date.parse('2020-01-12')
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
            start_dates = ['2020-01-10','2020-01-06','2020-01-07','2020-01-13']
            end_dates = ['2020-01-12','2020-01-14','2020-01-18','2020-01-22']
            
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
            reservation_id = 1200
            reservation = @hotel_system.get_reservation_total_cost(reservation_id)
            assert_nil (reservation)
        end
    end
    
    describe "create_hotel_block method" do
        before do
            start_date1 = '2020-01-10'
            end_date1 = '2020-01-13'
            # make reservations on the same date range for every room
            @expected_number_of_rooms.times do 
                @hotel_system.make_reservation(start_date1, end_date1)
            end
            
            start_date2 = '2020-01-13'
            end_date2 = '2020-01-17'
            # make another reservation for room #1
            @hotel_system.make_reservation(start_date2, end_date2)
            @discount_rate = 0.20
        end
        
        it "creates a block for valid rooms, date_range, discount_rate" do
            rooms = [2, 3, 4]
            start_date = '2020-01-20'
            end_date = '2020-01-23'
            
            date_range = Hotel::DateRange.new(start_date, end_date)
            expect (@hotel_system.hotel_blocks).must_be_empty
            
            @hotel_system.create_hotel_block(rooms: rooms, date_range: date_range, discount: @discount_rate)
            expect (@hotel_system.hotel_blocks).wont_be_empty  
        end
        
        it "raises ArgumentError when user creates a block that belongs to another block for the given date range" do
            rooms1 = [2, 3, 4]
            start_date1 = '2020-01-20'
            end_date1 = '2020-01-23'
            
            date_range1 = Hotel::DateRange.new(start_date1, end_date1)
            @hotel_system.create_hotel_block(rooms: rooms1, date_range: date_range1, discount: @discount_rate)
            expect (@hotel_system.hotel_blocks).wont_be_empty
            
            # create a block contains a room in another block on overlapping date_range
            rooms2 = [4, 5, 6]
            start_date2 = '2020-01-21'
            end_date2 = '2020-01-25'
            date_range2 = Hotel::DateRange.new(start_date2, end_date2)
            expect {
                @hotel_system.create_hotel_block(rooms: rooms2, date_range: date_range2, discount: @discount_rate)
            }.must_raise ArgumentError
        end
        
        it "raises ArgumentError when user creates a block that has a booked room for the given date range" do
            rooms1 = [2, 3, 4]
            start_date1 = '2020-01-20'
            end_date1 = '2020-01-23'
            
            date_range1 = Hotel::DateRange.new(start_date1, end_date1)
            @hotel_system.create_hotel_block(rooms: rooms1, date_range: date_range1, discount: @discount_rate)
            expect (@hotel_system.hotel_blocks).wont_be_empty
            
            # make reservation on the first room available in this date range (room #1)
            @hotel_system.make_reservation(start_date1, end_date1)
            
            rooms3 = [1, 12, 13]
            expect {
                @hotel_system.create_hotel_block(rooms: rooms3, date_range: date_range1, discount: @discount_rate)
            }.must_raise ArgumentError
        end
        
        it "raises ArgumentError if user creates a block with more than 5 rooms" do
            rooms = [2, 3, 4, 5, 7, 10]
            start_date = '2020-01-20'
            end_date = '2020-01-23'
            
            date_range = Hotel::DateRange.new(start_date, end_date)
            expect {
                @hotel_system.create_hotel_block(rooms: rooms, date_range: date_range, discount: @discount_rate)
            }.must_raise ArgumentError
            
        end
        
        it "raises ArgumentError if user creates a block that has duplicate room" do
            rooms = [2, 3, 4, 4, 7]
            start_date = '2020-01-20'
            end_date = '2020-01-23'
            
            date_range = Hotel::DateRange.new(start_date, end_date)
            expect {
                @hotel_system.create_hotel_block(rooms: rooms, date_range: date_range, discount: @discount_rate)
            }.must_raise ArgumentError
        end
        
        it "raises ArgumentError if user creates a block that has nonexistent room" do
            rooms = [2, 3, 4, 4, 27]
            start_date = '2020-01-20'
            end_date = '2020-01-23'
            
            date_range = Hotel::DateRange.new(start_date, end_date)
            expect {
                @hotel_system.create_hotel_block(rooms: rooms, date_range: date_range, discount: @discount_rate)
            }.must_raise ArgumentError
        end
    end
    
    describe "available_rooms_by_hotel_block method" do
        before do 
            @rooms = [2, 3, 4]
            start_date = '2020-01-20'
            end_date = '2020-01-23'
            
            date_range = Hotel::DateRange.new(start_date, end_date)
            @hotel_system.create_hotel_block(rooms: @rooms, date_range: date_range)
            @block_id = @hotel_system.hotel_blocks.first.id
        end
        
        it "returns an array of available room of a given block" do
            available_rooms = @hotel_system.available_rooms_by_hotel_block(@block_id)
            expect (available_rooms).must_equal @rooms
        end
        
        it "raises ArgumentError if the given block doesn't exist" do
            block_id = 300  
            expect {@hotel_system.available_rooms_by_hotel_block(block_id)}.must_raise ArgumentError
        end
        
        it "returns empty array if the given block doesn't have any available room" do
            available_rooms = @hotel_system.available_rooms_by_hotel_block(@block_id)
            expect (available_rooms).must_equal @rooms
            
            @rooms.each do |room|
                @hotel_system.reserve_room(room)
            end
            expect (@hotel_system.available_rooms_by_hotel_block(@block_id)).must_be_empty
        end
    end
    
    describe "available_rooms_by_hotel_block method" do
        before do 
            @rooms = [2, 3, 4]
            start_date = '2020-01-20'
            end_date = '2020-01-23'
            @duration = 3
            
            @date_range = Hotel::DateRange.new(start_date, end_date)
            @hotel_system.create_hotel_block(rooms: @rooms, date_range: @date_range)
            @block_id = @hotel_system.hotel_blocks.first.id
            @discount = 0.20
            @cost_per_night = 200.00
        end
        
        it "can reserve a room in a hotel block for the entire duration" do
            discounted_cost = @cost_per_night * (1 - @discount) * @duration
            expect (@hotel_system.reservations).must_be_empty
            
            @rooms.each do |room|
                @hotel_system.reserve_room(room)
            end
            
            expect (@hotel_system.reservations.length).must_equal @rooms.length
            @hotel_system.reservations.each do |reservation| 
                expect (reservation.date_range).must_equal @date_range
                expect (reservation.cost).must_equal discounted_cost
            end
        end
        
        it "raises exception if user reserves a room that doesn't belong to any hotel block" do
            room_number = 19
            expect {@hotel_system.reserve_room(room_number)}.must_raise ArgumentError
        end
        
    end
end