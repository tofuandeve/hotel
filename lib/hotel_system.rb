module Hotel
    class HotelSystem
        RATE = 200.00
        NUMBER_OF_ROOM = 20
        DISCOUNT = 0.20
        
        attr_reader :number_of_rooms, :hotel_blocks
        
        def initialize(input_number_of_rooms = NUMBER_OF_ROOM)
            @rooms = Hash.new   
            number_of_rooms.times do |index|
                @rooms[(index + 1)] = Array.new
            end
            @room_numbers = @rooms.keys
            @hotel_blocks = Array.new
            @current_block_id = 0
            @current_reservation_id = 0
        end
        
        def number_of_rooms
            return NUMBER_OF_ROOM
        end
        
        def reservations
            return @rooms.values.flatten
        end
        
        def make_reservation(start_date, end_date)
            date_range = DateRange.new(start_date, end_date)
            available_rooms = find_available_rooms(date_range)
            
            if available_rooms.empty?
                raise ArgumentError.new("No rooms available in this date range!")
            end
            
            @current_reservation_id += 1
            @rooms[available_rooms.first] << Reservation.new(date_range, RATE, @current_reservation_id)
        end
        
        def find_reservation_by_date(date)
            output = reservations.select do |reservation| 
                (reservation.date_range.start_date <= date) &&
                (date < reservation.date_range.end_date)
            end
            return output
        end
        
        def get_reservation_total_cost(reservation_id)
            output_reservation = reservations.find { |reservation| reservation.id == reservation_id }
            if !output_reservation
                return nil
            end
            return output_reservation.cost
        end
        
        def find_available_rooms(date_range)
            blocked_rooms = find_blocked_rooms_overlap_in_date_range(date_range)
            available_rooms = @room_numbers.select { 
                |number| !has_overlapping(@rooms[number], date_range) && !blocked_rooms.include?(number)
            }
            return available_rooms
        end
        
        def create_hotel_block(rooms, date_range, discount = DISCOUNT)
            if rooms == nil || rooms.uniq != rooms || 
                rooms.any? { |room| !@room_numbers.include?(room)} 
                raise ArgumentError.new("Rooms cannot be duplicate or nil")
            end
            
            available_rooms = find_available_rooms(date_range)
            unavailable_room = rooms.find { |room| !available_rooms.include?(room) }
            if unavailable_room
                raise ArgumentError.new("Room number #{unavailable_room} is not available on this date range!")
            end
            
            @current_block_id += 1
            @hotel_blocks << HotelBlock.new(@current_block_id, rooms, date_range, discount)
        end
        
        private
        def has_overlapping(list, date_range)
            return list.any? {|reservation| reservation.date_range.overlap?(date_range) }
        end
        
        def find_blocked_rooms_overlap_in_date_range(date_range)
            blocked_rooms = Array.new
            @hotel_blocks.each do |block|
                if block.date_range.overlap?(date_range)
                    block.rooms.each do |room|
                        blocked_rooms << room
                    end
                end
            end
            return blocked_rooms
        end
    end
end