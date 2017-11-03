class JsController < ApplicationController

  protect_from_forgery except: :semenhub

  def secure
    false
  end

  def semenhub
    @animals = Animal.all
  end
end
