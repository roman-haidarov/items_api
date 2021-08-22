class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from JWT::DecodeError, with: :render_parse_error

  include AccessHandler

  private

  def render_not_found
    render json: { message: "Record not found" }, status: 404 
  end

  def render_parse_error
    render json: { message: "Invalid token" }, status: 400
  end
end
