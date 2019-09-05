module Hotel
    class HotelSystem
        RATE = 200.00
        NUMBER_OF_ROOM = 20
        
        attr_reader :number_of_rooms
        
        def initialize(input_number_of_rooms = NUMBER_OF_ROOM)
            @rooms = Hash.new   
            @number_of_rooms = input_number_of_rooms
            number_of_rooms.times do |index|
                @rooms[(index + 1)] = Array.new
            end
            
        end
        
        def reservations
            return @rooms.values.flatten
        end
        
        def reservation_ids
            return reservations.map { |reservation| reservation.id }
        end
        
        def make_reservation(start_date, end_date)
            room_reservations_pair = @rooms.find { |number, reservations| reservations.empty? }
            if room_reservations_pair
                date_range = DateRange.new(start_date, end_date)
                
                reservation_id = rand(1000..9999)
                while reservation_ids.include? reservation_id
                    reservation_id = rand(1000..9999)
                end
                @rooms[room_reservations_pair[0]] << Reservation.new(date_range, RATE, reservation_id)
            end
        end
    end
end