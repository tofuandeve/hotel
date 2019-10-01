module Hotel
  class Reservation
    @@current_id = 0
    attr_reader :id, :date_range, :rate, :cost, :room_number
    
    def initialize(date_range:, rate:, room_number:)
      @@current_id += 1
      @date_range = date_range
      @rate = rate
      @id = @@current_id
      @cost = (date_range.start_date - date_range.end_date).abs * rate
      @room_number = room_number
    end

    def details 
      return "ID: #{id} -- Room number: #{room_number} -- Checkin: #{date_range.start_date} -- Checkout: #{date_range.end_date} -- total: $#{cost}"
    end
  end
end