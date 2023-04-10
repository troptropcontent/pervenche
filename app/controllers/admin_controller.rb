# frozen_string_literal: true

class AdminController < ApplicationController
  skip_load_and_authorize_resource
  before_action :authorize_action!

  def dashboard; end

  private

  def authorize_action!
    authorize! action_name.to_sym, :admin
  end
end
