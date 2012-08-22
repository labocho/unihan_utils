require "sqlite3"
require "active_record"

module UnihanUtils
  class Base < ActiveRecord::Base
    DATABASE_PATH = "#{File.dirname(__FILE__)}/../../db/unihan.db"

    self.abstract_class = true

    def self.init
      return false if @initialized
      @create_table = true unless File.exists?(DATABASE_PATH)
      establish_connection(
        adapter: "sqlite3",
        database: DATABASE_PATH
      )
      create_tables if @create_table
      @initialized = true
    end

    def self.create_tables
      connection.execute <<-SQL
        CREATE TABLE characters (
          codepoint integer
            not null
            primary key
        )
      SQL

      connection.execute <<-SQL
        CREATE TABLE characters_variants (
          id integer
            not null
            primary key
            autoincrement,
          codepoint integer
            not null
            references characters (codepoint),
          relation text
            not null,
          variant_codepoint integer
            not null
            references characters (codepoint)
        )
      SQL

      connection.execute <<-SQL
        CREATE TABLE variant_sources (
          id integer
            not null
            primary key,
          characters_variants_id integer
            not null
            references characters_variants (id),
          source text
            not null
        )
      SQL
    end

    def self.codepoint_from_uplus(uplus)
      uplus.sub(/^U\+/, "").to_i(16)
    end
  end
end
