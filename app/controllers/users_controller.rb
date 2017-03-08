class UsersController < ApplicationController

  def secure
    if ["new","create","profile"].include?(params[:action])
      return false
    end
    if current_user and current_user.id.to_s == params[:id] and ["show","edit","update","editpassword","updatepassword"].include?(params[:action])
      return false
    end
    true
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
    redirect_to current_user if current_user
    redirect_to '/login' unless current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    put_address_in_user(@user)

    if @user.save
      @user.roles << Role.find_by_name(:default)
      redirect_to @user
    else
      render :new
    end

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    @user.update(user_params)

    put_address_in_user(@user)

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    return unless current_user.can? :delete_users
    @user = User.find(params[:id])
    @user.destroy
    redirect_to User
  end

  def editpassword
    @user = User.find(params[:id])
  end

  def updatepassword
    @user = User.find(params[:id])
    if @user.update password_params
      redirect_to @user
    else
      render :editpassword
    end
  end

  def editrole
    @user = User.find(params[:id])
  end

  def updaterole
    @user = User.find(params[:id])
    @user.roles.delete_all
    role_params.each do |r|
      @user.roles << Role.find_by_name(r)
    end
    redirect_to @user
  end

  def createtemppassword

  end

  protected

  def put_address_in_user(user)

    user.mailing_address.update(mailing_address_params) if user.mailing_address
    user.mailing_address = Address.new(mailing_address_params) unless user.mailing_address

    billing_address_use_other = params.require(:user).require(:billing_address).require(:options).require(:use_other)

    if billing_address_use_other == "mailing"
      user.billing_address.destroy if user.billing_address && user.billing_address != user.mailing_address
      user.billing_address = user.mailing_address
    else
      user.billing_address = Address.new if user.billing_address == user.mailing_address || !(user.billing_address)
      user.billing_address.update(billing_address_params)
    end

    payee_address_use_other = params.require(:user).require(:payee_address).require(:options).require(:use_other)

    if payee_address_use_other == "custom"
      user.payee_address = Address.new unless user.payee_address
      user.payee_address.update(payee_address_params)
    else
      remove_payee_address(user)
      if payee_address_use_other == "mailing"
        user.payee_address = user.mailing_address
      elsif payee_address_use_other == "billing"
        user.payee_address = user.billing_address
      end
    end

    user.mailing_address.validate
    user.billing_address.validate
    user.payee_address.validate if user.payee_address

    user
  end

  def remove_payee_address(user)
    if user.payee_address
      user.payee_address.destroy unless user.payee_address == user.mailing_address || user.payee_address == user.billing_address
      user.payee_address = nil
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :spouse_name, :email, :phone_primary, :phone_secondary, :website, :password, :password_confirmation
    )
  end

  def password_params
    params.require(:user).permit(:password, :password_params)
  end

  def mailing_address_params
    params.require(:user).require(:mailing_address).permit(
      :line1, :line2, :postal_code, :city, :region, :alpha_2
    )
  end

  def billing_address_params
    params.require(:user).require(:billing_address).permit(
      :line1, :line2, :postal_code, :city, :region, :alpha_2
    )
  end

  def payee_address_params
    params.require(:user).require(:payee_address).permit(
      :line1, :line2, :postal_code, :city, :region, :alpha_2
    )
  end

  def role_params
    params.permit(Role.all.map{|r| r.name})
  end

  def rand_pass
    o = [('a'..'z'), ('A'..'Z'), ('1'..'0')].map(&:to_a).flatten
    string = (0...10).map { o[rand(o.length)] }.join
  end
end
