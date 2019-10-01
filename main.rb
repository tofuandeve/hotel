require_relative 'lib/hotel_system'

OPTIONS = [
    "reservations list", 
    "total rooms", 
    "make reservation", 
    "find reservations",
    "exit"
]

def display_available_options()
    puts OPTIONS
end

def get_user_decision()
    decision = gets.chomp()
    while !OPTIONS.include?(decision)
        puts "\nInvalid decision, please enter in a valid decision: "
        display_available_options()
        decision = gets.chomp()
    end
    return decision
end

def get_date_from_user()
    date_input = gets.chomp()
    date = Date.parse(date_input) rescue nil
    while !date
        puts "\nInvalid input for date. Date should be formatted correctly"
        print "Please enter in valid input: YYYY-MM-DD (example: 2020-12-30): "
        date_input = gets.chomp()
        date = Date.parse(date_input) rescue nil
    end
    return date
end

def display_reservations_list(reservations)
    reservations.each do |reservation|
        puts reservation.details()
    end
end

def main()
    puts "Welcome to Hotel System Simulation!"
    hotel_system = Hotel::HotelSystem.new()

    while true
        puts "\nWhat would you like to do: "
        display_available_options()
        user_decision = get_user_decision()
        
        case user_decision
        when "reservations list"
            puts hotel_system.reservations_details
            
        when "total rooms"
            puts hotel_system.number_of_rooms
            puts

        when "make reservation"
            print "\nPlease enter in checkin date (YYYY-MM-DD): "
            checkin = get_date_from_user()
            print "\nPlease enter in checkout date (YYYY-MM-DD): "
            checkout = get_date_from_user()
            
            begin
                hotel_system.make_reservation(checkin, checkout) 
            rescue ArgumentError
                puts "\nInvalid dates: #{checkin} - #{checkout}\n\n"
            rescue StandardError
                puts "\nThere's no room available in this date range #{checkin} - #{checkout}\n\n"
            else
                puts "\nReservation has been created!\n\n"
            end
            
        when "find reservations"
            print "\nPlease enter in a date to find reservations "
            date = get_date_from_user()
            found_reservations = hotel_system.find_reservation_by_date(date)
            found_reservations.empty? ? puts("There is no reservation on #{date}\n\n") : display_reservations_list(found_reservations)
            
        when "exit"
            exit 
        end
    end 
end

main if __FILE__ == $PROGRAM_NAME