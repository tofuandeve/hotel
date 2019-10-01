require_relative 'date_range'
require_relative 'reservation'
require_relative 'hotel_block'

module Hotel
  class HotelSystem
    RATE = 200.00
    NUMBER_OF_ROOMS = 20
    DISCOUNT = 0.20
    
    attr_reader :hotel_blocks, :rooms
    
    def initialize(input_number_of_rooms = NUMBER_OF_ROOMS)
      @room_reservation_data = Hash.new   
      input_number_of_rooms.times do |index|
        @room_reservation_data[(index + 1)] = Array.new
      end
      @rooms = @room_reservation_data.keys
      @hotel_blocks = Array.new
    end
    
    def number_of_rooms
      return NUMBER_OF_ROOMS
    end
    
    def reservations
      return @room_reservation_data.values.flatten
    end
    
    def reservations_details
      return reservations.map {|reservation| reservation.details }
    end
    
    def make_reservation(start_date, end_date)
      date_range = DateRange.new(start_date, end_date)
      available_rooms = find_available_rooms(date_range)
      
      if available_rooms.empty?
        raise StandardError.new("No rooms available in this date range: #{start_date} - #{end_date}!")
      end
      
      room_number = available_rooms.first
      reservation = create_reservation(date_range: date_range, rate: RATE, room_number: room_number)
      @room_reservation_data[room_number] << reservation
    end
    
    def find_reservation_by_date(date)
      output = reservations.select do |reservation| 
        (reservation.date_range.start_date <= date) &&
        (date < reservation.date_range.end_date)
      end
      return output
    end
    
    def get_reservation_total_cost(reservation_id)
      output_reservation = reservations.find { |reservation| reservation.id == reservation_id }
      if !output_reservation
        return nil
      end
      return output_reservation.cost
    end
    
    def find_available_rooms(date_range)
      raise ArgumentError.new('Date range cannot be nil') if !date_range
      
      blocked_rooms = find_overlapping_rooms_in_hotel_blocks(date_range)
      available_rooms = @rooms.select do |number| 
        !has_overlapping(@room_reservation_data[number], date_range) &&
        !blocked_rooms.include?(number)
      end
      return available_rooms
    end
    
    def create_hotel_block(rooms:, date_range:, discount: DISCOUNT)
      if rooms == nil ||
        rooms.uniq != rooms || 
        rooms.any? { |room| !@rooms.include?(room)} 
        
        raise ArgumentError.new("Rooms cannot be duplicate or nil")
      end
      
      available_rooms = find_available_rooms(date_range)
      unavailable_room = rooms.find { |room| !available_rooms.include?(room) }
      if unavailable_room
        raise ArgumentError.new(
          "Room number #{unavailable_room} is not available on this date range!"
        )
      end
      
      hotel_block = create_block(rooms: rooms, date_range: date_range, discount: discount)
      @hotel_blocks << hotel_block
    end
    
    def available_rooms_in_block(block_id)
      hotel_block = @hotel_blocks.find do |block| 
        block.id == block_id
      end
      
      raise ArgumentError.new("Block #{block_id} doesn't exist") if !hotel_block   
      return hotel_block.rooms
    end
    
    def reserve_room(room_number)
      hotel_block_index = find_block_index(room_number)
      if !hotel_block_index
        raise ArgumentError.new("Room #{room_number} doesn't belong to any block") 
      end
      
      block = @hotel_blocks[hotel_block_index]
      
      # add make new reservation for the input room
      reservation = create_reservation(date_range: block.date_range, rate: RATE * (1 - block.discount_rate), room_number: room_number)
      @room_reservation_data[room_number] << reservation
      
      # remove room out of block's room list
      @hotel_blocks[hotel_block_index].rooms.delete(room_number)
    end
    
    private
    def has_overlapping(reservations, date_range)
      return reservations.any? {|reservation| reservation.date_range.overlap?(date_range) }
    end
    
    def find_overlapping_rooms_in_hotel_blocks(date_range)
      blocked_rooms = Array.new
      @hotel_blocks.each do |block|
        if block.date_range.overlap?(date_range)
          blocked_rooms += block.rooms
        end
      end
      return blocked_rooms
    end
    
    def find_block_index(room_number)
      return @hotel_blocks.find_index { |block| block.rooms.include?(room_number)}
    end
    
    def create_reservation(date_range:, rate:, room_number:)
      return Reservation.new(date_range: date_range, rate: rate, room_number: room_number)
    end
    
    def create_block(rooms:, date_range:, discount:)
      return HotelBlock.new(rooms: rooms, date_range: date_range, discount_rate: discount)
    end
  end
end