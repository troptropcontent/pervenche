class RadioTilesWithIconInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    # merged_input_options = merge_wrapper_options(input_html_options, wrapper_options
    tile_with_icons = options[:collection].map do |collection_item|
      tile_with_icon(collection_item)
    end
    template.content_tag(:div, class: 'form__input__tiles') do
      tile_with_icons.join('').html_safe
    end
  end

  def label(_); end

  private

  def tile_with_icon(collection_item)
    title = collection_item[0]
    value = collection_item[1]
    options = collection_item[2] || {}
    options[:disabled] ? fake_tile(title, value) : real_tile(title, value)
  end

  def real_tile(title, value)
    template.content_tag(:label, class: 'form__input__tiles__tile_with_icon', id: value) do
      [
        @builder.input_field(attribute_name, type: 'radio', class: 'visually-hidden', value: value),
        template.content_tag(:span) do
          [
            template.image_tag(value + '.png'),
            template.tag.p(title)
          ].join('').html_safe
        end
      ].join('').html_safe
    end
  end

  def fake_tile(title, value)
    template.content_tag(:div,
                         class: 'form__input__tiles__tile_with_icon form__input__tiles__tile_with_icon--disabled', id: value) do
      [
        template.content_tag(:span) do
          [
            template.image_tag(value),
            template.tag.p("#{title} *")
          ].join('').html_safe
        end
      ].join('').html_safe
    end
  end
end
