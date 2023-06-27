# frozen_string_literal: true

class GenericJob
  include Sidekiq::Job

  def perform(receiver_class, method, options = {})
    method_args = options['method_args']
    receiver = receiver_class.constantize
    receiver = receiver.find(options['find_id']) if options['find_id']
    receiver = receiver.new(*options['new_args']) if options['new_args']
    if method_args
      method_args = [method_args] unless method_args.is_a?(Array)
      receiver.send(method, *method_args)
    else
      receiver.send(method)
    end
  end
end
