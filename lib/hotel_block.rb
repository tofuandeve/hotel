module Hotel
    class HotelBlock
        MAX_NUMBER_OF_ROOMS = 5
        @@current_id = 0
        attr_reader :id, :rooms, :discount_rate, :date_range

        def initialize(rooms:, date_range:, discount_rate:)
            @@current_id += 1
            @id = @@current_id
            @rooms = rooms.dup
            @date_range = date_range
            @discount_rate = discount_rate
            
            if rooms.length <= 0 || rooms.length > MAX_NUMBER_OF_ROOMS
                raise ArgumentError.new("Can only add up to #{MAX_NUMBER_OF_ROOMS} rooms to a block!")
            end
        end
    end  
end