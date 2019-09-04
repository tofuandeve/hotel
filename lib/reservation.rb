module Hotel
    class Reservation
        attr_reader :id, :date_range, :rate, :cost
        
        def initialize(date_range, rate, id)
            @date_range = date_range
            @rate = rate
            @id = id
            @cost = (date_range.start_date - date_range.end_date).abs * rate
        end
    end
end