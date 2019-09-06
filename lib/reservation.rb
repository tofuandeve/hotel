module Hotel
    class Reservation
        @@current_id = 0
        attr_reader :id, :date_range, :rate, :cost
        
        def initialize(date_range:, rate:)
            @@current_id += 1
            @date_range = date_range
            @rate = rate
            @id = @@current_id
            @cost = (date_range.start_date - date_range.end_date).abs * rate
        end
    end
end