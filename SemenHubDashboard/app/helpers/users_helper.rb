module UsersHelper
  def get_field_errors(model, field, text=field.to_s)
    return text.humanize unless model
    "#{text} #{model.errors[field].count > 0 ? "error#{model.errors[field].count > 1 ? 's' : ''}:#{model.errors[field].reduce(" "){|errors,error| "#{errors}#{error}, "}[0..-3]}" : ''}".humanize
  end

  def get_billing_address_option_mailing
    !(@user.billing_address) || @user.billing_address == @user.mailing_address
  end

  def get_billing_address_option_custom
    @user.billing_address && @user.billing_address != @user.mailing_address
  end

  def get_payee_address_option_false
    !(@user.payee_address)
  end

  def get_payee_address_option_mailing
    @user.payee_address && @user.payee_address == @user.mailing_address
  end

  def get_payee_address_option_billing
    @user.payee_address && @user.payee_address == @user.billing_address && @user.billing_address != @user.mailing_address
  end

  def get_payee_address_option_custom
    @user.payee_address && @user.payee_address != @user.mailing_address && @user.payee_address != @user.billing_address
  end


end
