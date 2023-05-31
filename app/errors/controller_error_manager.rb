# frozen_string_literal: true

module ControllerErrorManager
  def self.included(klass)
    klass.class_eval do
      ###########
      ### 422 ###
      ###########
      rescue_from ActiveRecord::RecordInvalid,
                  ActiveRecord::DeleteRestrictionError,
                  ActiveRecord::RecordNotSaved,
                  ActiveRecord::RecordNotDestroyed,
                  ActiveModel::ValidationError do |error|
        render json: { code: :unprocessable_entity, message: error }, status: :unprocessable_entity
      end

      ###########
      ### 404 ###
      ###########
      rescue_from ActiveRecord::RecordNotFound do |error|
        render json: { code: :not_found, message: error }, status: :not_found
      end

      ###########
      ### 403 ###
      ###########

      rescue_from CanCan::AccessDenied do
        render json: { code: :forbidden, message: I18n.t('errors.controller.forbidden.message') }, status: :forbidden
      end

      ###########
      ### 400 ###
      ###########
      rescue_from ActionController::BadRequest, Pervenche::Errors::InvalidState do |error|
        render json: { code: :bad_request, message: error }, status: :bad_request
      end

      rescue_from ActionController::ParameterMissing do |error|
        message = I18n.t('errors.controller.parameter_missing.general_message')
        if error.param.present?
          message = I18n.t('errors.controller.parameter_missing.specific_message',
                           param: error.param)
        end
        render json: { code: :parameter_missing, message: }, status: :bad_request
      end
    end
  end
end
