class ApplicationController < ActionController::API
  rescue_from InvalidParameter, with: :unprocessable_entity

  def unprocessable_entity(exception)
    render json: {errors: ["Unprocessable entity exception. Invalid parameter."]}.to_json, status: :unprocessable_entity
  end
end
