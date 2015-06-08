# @ref マイグレーション(migration) - - Railsドキュメント
# @url http://railsdoc.com/migration
require 'active_record'

class CreateSourceTableBenchmark < ActiveRecord::Migration
  def self.up
    create_table :source_bench do |t|
      t.string :dummy_pk, null: false
      t.string :search_key, null: false
      t.string :include_col1_id
      t.string :include_col2_id
      t.string :exclude_col1
      t.string :exclude_col2
      t.string :acceptable_col1
      t.string :acceptable_col2

      types = %i(string
                 text
                 integer
                 float
                 decimal
                 time
                 date
                 boolean)
                 # datetime
                 # timestamp
                 # binary
      types.each { |type| t.send(type, "#{type}_col") }

      900.times do |i|
        t.string "dummy_col_#{sprintf('%03d', i)}"
      end
    end
  end

  def self.down
    drop_table :source_bench
  end
end
