# frozen_string_literal: true

class Category < ActiveYaml::Base
  set_root_path "#{Rails.root}/db/active_yaml"

  def parent_category
    Category.find_by(category_id: parent_category_id)
  end

  include ActiveHash::Associations
end