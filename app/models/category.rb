# frozen_string_literal: true

class Category < ActiveYaml::Base
  set_root_path "#{Rails.root}/db/active_yaml"

  include ActiveHash::Associations
end