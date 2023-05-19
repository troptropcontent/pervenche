# frozen_string_literal: true

class TypePickerInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @multiple = options[:multiple]
    input_name = object.send(attribute_name).is_a?(Array) ? "[#{attribute_name}][]" : "[#{attribute_name}]"
    types = options[:collection].map do |(content, value)|
      type(content, value, input_name)
    end
    types.join.html_safe
  end

  private

  def type(content, value, input_name)
    label_tag(value) do
      [
        @multiple ? check_box(value, input_name) : radio_button(value, input_name),
        clickable(content)
      ].join.html_safe
    end
  end

  def check_box(value, input_name)
    template.check_box_tag(
      *input_args(value, input_name)
    )
  end

  def radio_button(value, input_name)
    template.radio_button_tag(
      *input_args(value, input_name)
    )
  end

  def input_args(value, input_name)
    [
      "#{object_name}#{input_name}",
      value,
      @multiple ? object.send(attribute_name).include?(value) : object.send(attribute_name) == value,
      { class: 'visually-hidden',
        id: "#{object_name}_#{attribute_name}_#{value}" }
    ]
  end

  def clickable(content)
    template.content_tag(:div, class: 'clickable') do
      template.content_tag(:h4, content, class: 'clickable')
    end
  end

  def label_tag(value, &)
    template.label_tag("#{object_name}_#{attribute_name}_#{value}", class: 'form__input__type__picker__type', &)
  end
end
