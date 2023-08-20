class NotificationsController < ApplicationController
  skip_load_and_authorize_resource

  # POST /notifications/:type
  def create
    load_notification_class!
    load_recipient!

    @notification_class.with(notification_params.to_h.symbolize_keys).deliver(@recipient)
  end

  private

  def load_notification_class!
    notification_type_param = params[:type]
    klass = notification_type_param.safe_constantize

    raise raise_unknown_notification_type! if klass&.superclass != Noticed::Base

    @notification_class = klass
  end

  def load_recipient!
    @recipient = User.find(params.require(:notification).require(:recipient_id))
  end

  def raise_unknown_notification_type!
    raise Pervenche::Errors::NotFound, "The notification of type #{params[:type]} does not exists"
  end

  def notification_params
    params.require(:notification).permit(*@notification_class.params)
  end
end
