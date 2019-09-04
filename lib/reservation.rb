module Hotel
    class Reservation
        attr_reader :id, :date_range, :rate 

        def initialize(date_range, rate, id)
            @date_range = date_range
            @rate = rate
            @id = id
        end
    end
end