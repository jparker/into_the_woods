# frozen_string_literal: true

class Search < SearchLingo::AbstractSearch
  include SearchLingo::Parsers

  # Matches `3/29/23`, `3/29/23-3/30/23`
  parser(
    DateParser.new(Booking.arel_table[:date]) { |chain| chain.joins(:booking) }
  )

  # Matches `receipt: 3/29/23`, `receipt: 3/29/23-3/30/23`
  parser(
    DateParser.new(Receipt.arel_table[:date], modifier: 'receipt') { |chain|
      chain.joins(receivables: :receipt)
    }
  )

  # Matches `client: peter`
  parser do |token, chain|
    next unless token.modifier == 'client'

    chain.joins(booking: :client).merge Client.search(token.term)
  end

  # Matches `vendor: bugle`
  parser do |token, chain|
    next unless token.modifier == 'vendor'

    chain.joins(booking: :vendor).merge Vendor.search(token.term)
  end

  # The default parsers handles anything that wasn't matched above.
  def default_parse(token, chain)
    client = Client.search token.term
    vendor = Vendor.search token.term

    chain.joins(booking: %i[client vendor]).merge client.or(vendor)
  end
end
