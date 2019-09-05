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
        
        def create_unique_id
            reservation_id = rand(1000..9999)
            while reservation_ids.include? reservation_id
                reservation_id = rand(1000..9999)
            end
            return reservation_id
        end
        
        def make_reservation(start_date, end_date)
            date_range = DateRange.new(start_date, end_date)
            available_rooms = find_available_rooms(date_range)
            if !available_rooms.empty?
                reservation_id = create_unique_id
                @rooms[available_rooms.first] << Reservation.new(date_range, RATE, reservation_id)
            end
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
            available_rooms = Array.new
            @rooms.each do |number, reservation_list|
                if !has_overlapping(reservation_list, date_range)
                    available_rooms << number
                end
            end
            return available_rooms
        end

        def has_overlapping(list, date_range)
            return list.any? {|reservation| reservation.date_range.overlap?(date_range) }
        end
    end
end