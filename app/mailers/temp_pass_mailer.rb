class TempPassMailer < ApplicationMailer

  def send_temp_pass(user, temp_password)
    @user = user
    @temp_pass = temp_password
    mail(from: "accounts@semenhub.shop", to: user.email, subject: 'Temporary Password for SemenHub')
  end

end
