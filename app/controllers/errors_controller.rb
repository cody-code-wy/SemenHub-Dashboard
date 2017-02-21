class ErrorsController < ApplicationController

  def secure
    false #Anybody can see errors...
  end

  def perms
    nil #no perms required
  end

  def unauthorised
    render(status: 401)
  end

end
