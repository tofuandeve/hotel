require 'date'

module Hotel
    class DateRange
        attr_reader :start_date, :end_date
        
        def initialize(input_start_date, input_end_date)
            @start_date = Date.parse(input_start_date)
            @end_date = Date.parse(input_end_date)
            current_time = Date.today()
            
            if (@start_date - current_time < 0 ) || 
                (@end_date - current_time < 0)|| 
                (@end_date - @start_date <= 0)
                raise ArgumentError
            end
            
        end
    end
end