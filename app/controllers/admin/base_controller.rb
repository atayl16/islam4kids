# Admin::BaseController is the base authentication controller for all admin controllers.
module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    private

    def check_admin
      redirect_to root_url unless current_user.is_admin?
    end
  end
end
