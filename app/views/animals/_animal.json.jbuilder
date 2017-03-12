json.extract! animal, :id, :name, :owner_id, :breed_id, :private_herd_number, :dna_number, :created_at, :updated_at
json.url animal_url(animal, format: :json)
json.registrations animal.registrations do |registration|
  json.partial! "registrations/registration", registration: registration
end
