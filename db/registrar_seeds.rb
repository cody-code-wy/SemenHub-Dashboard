puts 'Creating Registrars'
Registrar.find_or_create_by(breed: Breed.find_or_create_by(breed_name: "Longhorn"), address: Address.find_or_create_by(line1: "P.O. Box 4430", city: "Fort Worth", region: "Texas", alpha_2: 'us', postal_code: "76164"), name: "TLBAA", phone_primary: "817-625-6241", phone_secondary: "817-625-1388", website: "http://www.tlba.org", email: "tlbaa@tlbaa.org", note: "Secondary phone number is FAX")

Registrar.find_or_create_by(breed: Breed.find_or_create_by(breed_name: "Longhorn"), address: Address.find_or_create_by(line1: "P.O. Box 2610", city: "Gren Rose", region: "Texas", alpha_2: 'us', postal_code: "76043"), name: "ITLA", phone_primary: "254-898-0157", website: "http://www.itla.com", email: "staff@itla.com")

Registrar.find_or_create_by(breed: Breed.find_or_create_by(breed_name: "Longhorn"), address: Address.find_or_create_by(line1: "P.O. Box PLACEHOLDER", city: "Place Holder", region: "Texas", alpha_2: 'us', postal_code: "76032"), name: "TLCA", phone_primary: "780-362-4321", website: "http://holdplacer.space", email: "user@holdplacer.space")
puts 'Created Registrars'
