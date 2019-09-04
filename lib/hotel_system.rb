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
    end
end