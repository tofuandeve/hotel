module Hotel
    class HotelSystem
        RATE = 200.00
        NUMBER_OF_ROOM = 20
        
        attr_reader :number_of_rooms
        
        def initialize(number_of_room = NUMBER_OF_ROOM)
            @data = Hash.new   
            number_of_room.times do |index|
                @data[(index + 1)] = Array.new
            end
            @number_of_rooms = number_of_room
        end
        
        def reservations
            return @data.values.flatten
        end
        
        def reservation_ids
            return reservations.map { |reservation| reservation.id }
        end
        
        def make_reservation(start_date, end_date)
            available_room = @data.find { |number, reservations| reservations.empty? }
            if available_room
                date_range = DateRange.new(start_date, end_date)
                
                reservation_id = rand(1000..9999)
                while reservation_ids.include? reservation_id
                    reservation_id = rand(1000..9999)
                end
                @data[available_room[0]] << Reservation.new(date_range, RATE, reservation_id)
            end
        end
    end
end