# @ref マイグレーション(migration) - - Railsドキュメント
# @url http://railsdoc.com/migration
require 'active_record'

class CreateTargetTable < ActiveRecord::Migration
  def self.up
    create_table :target, id: false do |t|
      t.string :dummy_pk, null: false
      t.string :search_key, null: false
      t.string :include_col1_id
      t.string :include_col2_id
      t.string :exclude_col1
      t.string :exclude_col2
      t.string :acceptable_col1
      t.string :acceptable_col2

      types = %i(string text
                 integer float decimal
                 datetime timestamp time date
                 binary
                 boolean)
      types.each { |type| t.send(type, "#{type}_col") }
    end
  end

  def self.down
    drop_table :target
  end
end
