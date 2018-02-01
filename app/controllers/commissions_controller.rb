class CommissionsController < ApplicationController

  def index
    @defaults = User.includes(:commission).where(commissions: {id: nil})

    @groups = Commission.select("commission_percent").group(:commission_percent)
    @users = {}
    @groups.each do |group|
      @users[group.commission_percent] = User.includes(:commission).where(commissions: {commission_percent: group.commission_percent})
    end
  end

  def create #API
    @user = User.find(params[:user])
    valid = Float(commission_params[:commission_percent]) rescue false
    unless valid
      return head :bad_request
    end
    @user.commission.update(commission_params)
    if @user.commission.save
      render json: @user.commission
    else
      return head :internal_server_error
    end
  end

  def destroy #API
    @user = User.find(params[:user])
    @user.commission.destroy
    @user = User.find(params[:user]) #Allows AR to get a new instance, so default commission can exist
    render json: @user.commission
  end

  private

  def commission_params
    params.permit(:commission_percent)
  end
end
