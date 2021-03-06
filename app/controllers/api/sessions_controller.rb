class Api::SessionsController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, fallback: :none
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  skip_before_action :verify_authenticity_token, :only => :create

  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      render json: {
          messages: "Signed In Successfully",
          is_success: true,
          data: {user: @user}
      }, status: :ok
    else
      render json: {
          messages: "Signed In Failed - Unauthorized",
          is_success: false,
          data: {}
      }, status: :unauthorized
    end
  end

  private
  def sign_in_params
    params.require(:user).permit :email, :password
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
  end
end