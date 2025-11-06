class UsersController < ApplicationController
    before_action :authenticate_user!
    def show
        @user = User.find(params[:id]) 
        @perfumes = current_user.perfumes.order(created_at: :desc)
    end
end
