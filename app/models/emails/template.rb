# frozen_string_literal: true

module Emails
  class Template
    class << self
      def template_id(template_id = nil)
        @template_id ||= template_id
      end

      def tags(*tags)
        @tags ||= tags
      end

      def template_data(*template_data)
        @template_data ||= template_data
      end

      def find(id)
        result = all.find { |template| template.template_id == id }
        raise Pervenche::Errors::NotFound if result.nil?

        result
      end

      def all
        load_mailers if descendants.empty?
        descendants
      end

      def load_mailers
        mailers = Dir[Rails.root.join('app/models/emails/**/*.rb')]
        mailers.each { |file| require file }
      end

      def to_partial_path
        'template'
      end
    end

    delegate :deliver_now, to: :mail
    delegate :deliver_later, to: :mail

    def mail
      TemplateMailer.with(
        to:,
        template_id: self.class.template_id,
        template_data:
      ).notify
    end

    attr_reader :to, :template_data

    def initialize(to:, template_data:)
      @to = to
      self.class.template_data.map do |template_data_field|
        @template_data ||= {}
        @template_data[template_data_field] = template_data.fetch(template_data_field)
      end
    end
  end
end
