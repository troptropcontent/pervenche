module ApplicationHelper
  def collection_table(collection:, fields:)
    # thead = content_tag :thead do
    #   content_tag :tr do
    #     fields.map { |field| concat content_tag(:th, field[:display_name]) }.join.html_safe
    #   end
    # end

    # tbody = content_tag :tbody do
    #   collection.collect do |elem|
    #     content_tag :tr do
    #       columns.collect do |column|
    #         concat content_tag(:td, elem.attributes[column[:name]])
    #       end.to_s.html_safe
    #     end
    #   end.join.html_safe
    # end

    # content_tag :table, thead.concat(tbody)
  end
end
