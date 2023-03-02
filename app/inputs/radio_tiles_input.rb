class RadioTilesInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    # merged_input_options = merge_wrapper_options(input_html_options, wrapper_options
    tile_with_icons = options[:collection].map do |collection_item|
      tile(collection_item)
    end
    template.content_tag(:div, class: 'form__input__tiles') do
      tile_with_icons.join('').html_safe
    end
  end

  def label(_); end

  private

  def tile(collection_item)
    title = collection_item[0]
    subtitle = collection_item[1]
    value = collection_item[2]
    options = collection_item[3] || {}
    checked = !!options[:checked] 
    options[:disabled] ? fake_tile(title, subtitle, value) : real_tile(title, subtitle, value, checked: checked)
  end

  def real_tile(title, subtitle, value, checked:)
    template.content_tag(:label, id: value, class: 'form__input__tiles__tile') do
      [ 
          @builder.input_field(attribute_name, type: 'radio', class: 'visually-hidden', value: value, checked: checked),
          template.content_tag(:span, class: 'clickable') do
            [ 
              template.tag.h4(title),
              (template.tag.p(subtitle, class: 'text__size--s') if subtitle),
            ].join('').html_safe
          end
      ].join('').html_safe
    end
  end

  def fake_tile(title, subtitle, value)
    template.content_tag(:div, class: 'form__input__tiles__tile') do
      [ 
          template.content_tag(:span, class: 'clickable disabled') do
            [
              template.tag.h4(title),
              (template.tag.p(subtitle) if subtitle),
            ].join('').html_safe
          end
      ].join('').html_safe
    end
  end
end
