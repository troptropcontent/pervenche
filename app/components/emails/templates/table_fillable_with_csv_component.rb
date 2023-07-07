# frozen_string_literal: true

class Emails::Templates::TableFillableWithCsvComponent < ViewComponent::Base
  def initialize(rows:, columns:, template_id:)
    super()
    @rows = rows
    @columns = columns
    @template_id = template_id
  end
end
