json.extract! address, :line1, :line2, :postal_code, :city, :region, :alpha_2, :created_at, :updated_at
json.url address_url(address, format: :json)
