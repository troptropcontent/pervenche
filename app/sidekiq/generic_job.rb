class GenericJob
  include Sidekiq::Job

  def perform(receiver_class, method, arguments, options = {})
    arguments = [arguments] unless arguments.is_a?(Array)
    receiver = receiver_class.constantize
    receiver = receiver.find(options['find_id']) if options['find_id']
    receiver = receiver.new(*options['new_args']) if options['new_args']
    receiver.send(method, *arguments)
  end
end
