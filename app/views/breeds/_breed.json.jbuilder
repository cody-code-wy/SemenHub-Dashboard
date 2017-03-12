json.extract! breed, :id, :breed_name, :created_at, :updated_at
json.url breed_url(breed, format: :json)
json.registrars breed.registrars do |registrar|
  json.registrar_name registrar.name
end
