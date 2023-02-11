class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def slugify_name
    self.name = name.to_s.downcase.gsub(/\s+/, '_')
  end
end
