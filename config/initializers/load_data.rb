# frozen_string_literal: true

class Zipcodes
  YAML.load_file('config/initializers/data/zipcodes.yml').each do |(city_name, zipcodes)|
    instance_variable_set "@#{city_name}", zipcodes
    self.class.send(:attr_reader, city_name)
  end
end
