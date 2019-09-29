require_relative 'lib/hotel_system'

OPTIONS = [
    "reservations list", 
    "rooms list", 
    "make reservation", 
    "create block", 
    "reserve room",
    "find reservation",
    "available block room",
    "exit"
]

def display_available_options()
    puts OPTIONS
end

def get_user_decision()
    return gets.chomp()
end

def main()
    puts "Welcome to Hotel System Simulation!"
    hotel_system = Hotel::HotelSystem.new()
    while true
        display_available_options()
        print "What would you like to do: "
        user_decision = get_user_decision()
        
        case user_decision
        when "reservations list"
            puts hotel_system.reservations
        when "rooms list"
            puts hotel_system.number_of_rooms
        when "exit"
            exit 
        end
    end 
end

main if __FILE__ == $PROGRAM_NAME