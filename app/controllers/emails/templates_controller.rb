# frozen_string_literal: true

module Emails
  class TemplatesController < ApplicationController
    def index
      require_template_descendants if Emails::Template.descendants.empty?
      @mailers = Emails::Template.descendants
    end

    def show; end

    def deliver; end

    private

    def require_template_descendants
      mailers = Dir[Rails.root.join('app/models/emails/**/*.rb')]
      mailers.each { |file| require file }
    end
  end
end
