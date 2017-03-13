module AnimalsHelper
  def use_existing_breed

  end

  def use_new_breed

  end

  def humanize_registrations_registration(registration)
    case registration.count
    when 0
      ""
    when 1
      registration.first.registration
    else
      "Multiple registrations! " + registration.reduce("[") do |sum,reg|
        sum + reg.id.to_s + ","
      end + "]"
    end
  end

  def humanize_registrations_ai_certification(registration)
    case registration.count
    when 0
      ""
    when 1
      registration.first.ai_certification
    else
      "Error"
    end
  end
end
