# frozen_string_literal: true

module Emails
  class TemplatesController < ApplicationController
    def index
      load_mailers if TemplateMailer.descendants.empty?
      @mailers = TemplateMailer.descendants
    end

    def show; end

    def deliver; end

    private

    def load_mailers
      mailers = Dir[Rails.root.join('app/mailers/**/*.rb')]
      mailers.each { |file| require file }
    end
  end
end
