class Target < ActiveRecord::Base
  include ActiveRecord::Diff

  self.table_name = AppConfig.models[:target_table_name]
end
