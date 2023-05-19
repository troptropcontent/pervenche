# frozen_string_literal: true

class TypePickerInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    input_name = options[:multiple] ? "[#{attribute_name}][]" : "[#{attribute_name}]"
    types = options[:collection].map do |value|
      type(value, input_name)
    end
    types.join.html_safe
  end

  private

  def type(value, input_name)
    label_tag(value) do
      [
        options[:multiple] ? check_box(value, input_name) : radio_button(value, input_name),
        clickable(value)
      ].join.html_safe
    end
  end

  def check_box(value, input_name)
    template.check_box_tag("#{object_name}#{input_name}", value, false, class: 'visually-hidden',
                                                                        id: "#{object_name}_#{attribute_name}_#{value}")
  end

  def radio_button(value, input_name)
    template.radio_button_tag(
      "#{object_name}#{input_name}",
      value, false,
      class: 'visually-hidden',
      id: "#{object_name}_#{attribute_name}_#{value}"
    )
  end

  def clickable(value)
    template.content_tag(:div, class: 'clickable') do
      template.content_tag(:h4, value, class: 'clickable')
    end
  end

  def label_tag(value, &)
    template.label_tag("#{object_name}_#{attribute_name}_#{value}", class: 'form__input__type__picker__type', &)
  end
end
