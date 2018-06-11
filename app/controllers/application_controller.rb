class ApplicationController < ActionController::API
  rescue_from ActiveModel::StrictValidationFailed, with: :unprocessable_entity

  def unprocessable_entity(exception)
    render json: {errors: []}.to_json, status: :unprocessable_entity
  end
end
