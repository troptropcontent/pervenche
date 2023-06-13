# frozen_string_literal: true
# typed: true

class ApplicationEmail
  include Maillable
  def self.template_id(template_id)
    @template_id ||= template_id
  end

  def initialize(to:, template_data:)
    @to = to
    @template_data = template_data
    @template_id = self.class.instance_variable_get(:@template_id)
  end

  def deliver(async: true)
    if async
      deliver_later(to: @to, template_id: @template_id, template_data: @template_data)
    else
      deliver_now(to: @to, template_id: @template_id, template_data: @template_data)
    end
  end
end
