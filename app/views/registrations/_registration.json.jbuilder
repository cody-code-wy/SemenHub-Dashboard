json.extract! registration, :id, :registrar_id, :animal_id, :registration, :ai_certification, :note, :created_at, :updated_at
json.url registration_url(registration, format: :json)
json.registrar_name registration.registrar.name
