# frozen_string_literal: true

class SharedViewsController < ApplicationController
  skip_load_and_authorize_resource
  def loading
    @title = params.require(:title)
    @text = params.require(:text)
  end
end
