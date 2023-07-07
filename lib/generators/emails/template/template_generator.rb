class Emails::TemplateGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :template_id, type: :string, banner: 'template_id'
  class_option :tags, type: :array, default: [], banner: 'finance marketing'
  class_option :template_data, type: :array, default: [], banner: 'template_data template_data'
  def create_template_file
    @template_id = template_id
    @tags = options['tags']
    @template_data = options['template_data']
    template 'email.rb', "app/models/emails/templates/#{file_name}.rb"
  end
end
