$active_shipping = {
  "UPS" => ActiveShipping::UPS.new(
    login: ENV["UPS_USERNAME"],
    password: ENV["UPS_PASSWORD"],
    key: ENV["UPS_KEY"]
  ),
  "FedEx" => ActiveShipping::FedEx.new(
    login: ENV["FEDEX_METER_NUMBER"],
    password: ENV["FEDEX_PASSWORD"],
    key: ENV["FEDEX_KEY"],
    account: ENV["FEDEX_ACCOUNT"]
  )
}
