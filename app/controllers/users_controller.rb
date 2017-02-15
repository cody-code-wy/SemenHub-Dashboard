class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    put_address_in_user(@user)

    if @user.save
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
    @user = User.find(params[:id])
    @user.destroy
    redirect_to User
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
end
