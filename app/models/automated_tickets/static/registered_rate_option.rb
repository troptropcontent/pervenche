# frozen_string_literal: true

module AutomatedTickets
  module Static
    class RegisteredRateOption < ActiveYaml::Base
      set_root_path Rails.root.join('app/models')
    end
  end
end
