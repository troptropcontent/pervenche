# frozen_string_literal: true

module Emails
  class TemplatesController < ApplicationController
    before_action :require_template_descendants

    def index
      @templates = Emails::Template.descendants
    end

    def show
      @table_rows = []
      @table_columns = [:to, *@template.template_data]
    end

    # POST /emails/templates/:template_id/deliver
    def deliver
      @template_class = Emails::Template.find(params[:template_id])
      template_class_arguments = template_params.to_h.deep_symbolize_keys
      @template_class.new(**template_class_arguments).deliver_later
    end

    private

    def require_template_descendants
      return unless Emails::Template.descendants.empty?

      template_files = Dir[Rails.root.join('app/models/emails/**/*.rb')]
      template_files.each { |template_file| require template_file }
    end

    def template_params
      params.require(:template).permit(:to, template_data: @template_class.template_data)
    end
  end
end
