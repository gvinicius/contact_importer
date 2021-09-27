require 'securerandom'

class Api::V1::ImportsController < ApiController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    import = Import.create!(user: current_user, sheet: import_params[:file])
    import.run
    if import.status == :terminated
      render :index, status: :created
    else
      render json: import, status: :unprocessable_entity
    end
  end

  def index
    render json: Import.where(user: current_user)
  end

  private

  def import_params
    params.permit(:file, :format)
  end
end
