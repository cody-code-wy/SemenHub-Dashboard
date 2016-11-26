class CommissionsController < ApplicationController

  def index
    @defaults = User.includes(:commission).where(commissions: {id: nil})
    @groups = Commission.group(:commission_percent)
    @users = {}
    @groups.each do |group|
      @users[group.commission_percent] = User.includes(:commission).where(commissions: {commission_percent: group.commission_percent})
    end
  end
end
