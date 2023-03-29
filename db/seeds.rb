pete = Client.where(name: 'Peter Parker').first_or_create!
tony = Client.where(name: 'Tony Stark').first_or_create!
otto = Client.where(name: 'Otto Octavius').first_or_create!
bugle = Vendor.where(name: 'Daily Bugle').first_or_create!
stark = Vendor.where(name: 'Stark Industries').first_or_create!
oscorp = Vendor.where(name: 'Oscorp Industries').first_or_create!

[
  { client: pete, vendor: bugle, date: Date.new(2023, 3, 25) },
  { client: tony, vendor: stark, date: Date.new(2023, 3, 25) },
  { client: otto, vendor: oscorp, date: Date.new(2023, 3, 26) },
  { client: pete, vendor: stark, date: Date.new(2023, 3, 26) },
  { client: tony, vendor: stark, date: Date.new(2023, 3, 27) },
  { client: otto, vendor: oscorp, date: Date.new(2023, 3, 27) },
].each.with_index do |params, offset|
  Billable.offset(offset).first_or_create! do |billable|
    billable.build_booking(**params)
    billable.gross_rate = 1_000.0
    billable.commission_rate = 0.1
    billable.commission = billable.commission_rate * billable.gross_rate

    if offset < 3
      billable.receivables.build do |receivable|
        receivable.build_receipt date: Date.new(2023, 3, 28)
        receivable.gross_rate = billable.gross_rate
        receivable.commission_rate = billable.commission_rate
        receivable.commission = receivable.commission_rate * receivable.gross_rate

        billable.collected += receivable.gross_rate
      end
    end
  end
end

Billable.offset(6).first_or_create! do |billable|
  billable.build_booking client: pete, vendor: bugle, date: Date.new(2023, 3, 29)
  billable.gross_rate = 1_000.0
  billable.commission_rate = 0.1
  billable.commission = billable.commission_rate * billable.gross_rate

  billable.receivables.build do |receivable|
    receivable.build_receipt date: Date.new(2023, 3, 29)
    receivable.gross_rate = billable.gross_rate * 0.75
    receivable.commission_rate = billable.commission_rate
    receivable.commission = receivable.commission_rate * receivable.gross_rate

    billable.collected += receivable.gross_rate
  end

  billable.receivables.build do |receivable|
    receivable.build_receipt date: Date.new(2023, 3, 29)
    receivable.gross_rate = billable.gross_rate * 0.25
    receivable.commission_rate = billable.commission_rate
    receivable.commission = receivable.commission_rate * receivable.gross_rate

    billable.collected += receivable.gross_rate
  end
end
