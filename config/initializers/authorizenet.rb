$authorizenet = {login: ENV["AUTHORIZENET_LOGIN"], key: ENV["AUTHORIZENET_KEY"], gateway: ENV["AUTHORIZENET_GATEWAY"].to_sym}
$authorizenet[:simgateway] = case $authorizenet[:gateway]
                               when :production
                                 AuthorizeNet::SIM::Transaction::Gateway::LIVE
                               else
                                 AuthorizeNet::SIM::Transaction::Gateway::TEST
                               end
