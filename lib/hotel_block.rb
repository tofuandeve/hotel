module Hotel
    class HotelBlock
        @@current_id = 0
        attr_reader :id, :rooms, :discount_rate, :date_range

        def initialize(rooms:, date_range:, discount_rate:)
            @@current_id += 1
            @id = @@current_id
            @rooms = rooms.dup
            @date_range = date_range
            @discount_rate = discount_rate
            
            if rooms.length <= 0 || rooms.length > 5
                raise ArgumentError.new("Can only add up to 5 rooms to a block!")
            end
        end
    end  
end