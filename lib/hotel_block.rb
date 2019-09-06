module Hotel
    class HotelBlock
        attr_reader :id, :rooms, :discount_rate, :date_range

        def initialize(input_id, rooms, date_range, discount_rate)
            @id = input_id
            @rooms = rooms.dup
            @date_range = date_range
            @discount_rate = discount_rate
            
            if rooms.length <= 0 || rooms.length > 5
                raise ArgumentError.new("Can only add up to 5 rooms to a block!")
            end
        end
    end  
end