module ApplicationHelper
  def table_data(collection:, fields:)
    klass = collection.klass
    header = fields.map { |field| klass.human_attribute_name(field) }
    rows = collection.map do |element|
      fields.map { |field| element.send(field) }
    end
    {
      header:,
      rows:

    }
  end
end
