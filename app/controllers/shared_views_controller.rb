# frozen_string_literal: true

class SharedViewsController < ApplicationController
  def loading
    @title = params.require(:title)
    @text = params.require(:text)
  end
end
