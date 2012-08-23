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
          codepoint INTEGER
            NOT NULL
            PRIMARY KEY,
          kAccountingNumeric TEXT,
          kBigFive TEXT,
          kCangjie TEXT,
          kCantonese TEXT,
          kCCCII TEXT,
          kCheungBauer TEXT,
          kCheungBauerIndex TEXT,
          kCihaiT TEXT,
          kCNS1986 TEXT,
          kCNS1992 TEXT,
          kCompatibilityVariant TEXT,
          kCowles TEXT,
          kDaeJaweon TEXT,
          kDefinition TEXT,
          kEACC TEXT,
          kFenn TEXT,
          kFennIndex TEXT,
          kFourCornerCode TEXT,
          kFrequency TEXT,
          kGB0 TEXT,
          kGB1 TEXT,
          kGB3 TEXT,
          kGB5 TEXT,
          kGB7 TEXT,
          kGB8 TEXT,
          kGradeLevel TEXT,
          kGSR TEXT,
          kHangul TEXT,
          kHanYu TEXT,
          kHanyuPinlu TEXT,
          kHanyuPinyin TEXT,
          kHDZRadBreak TEXT,
          kHKGlyph TEXT,
          kHKSCS TEXT,
          kIBMJapan TEXT,
          kIICore TEXT,
          kIRG_GSource TEXT,
          kIRG_HSource TEXT,
          kIRG_JSource TEXT,
          kIRG_KPSource TEXT,
          kIRG_KSource TEXT,
          kIRG_MSource TEXT,
          kIRG_TSource TEXT,
          kIRG_USource TEXT,
          kIRG_VSource TEXT,
          kIRGDaeJaweon TEXT,
          kIRGDaiKanwaZiten TEXT,
          kIRGHanyuDaZidian TEXT,
          kIRGKangXi TEXT,
          kJapaneseKun TEXT,
          kJapaneseOn TEXT,
          kJis0 TEXT,
          kJis1 TEXT,
          kJIS0213 TEXT,
          kKangXi TEXT,
          kKarlgren TEXT,
          kKorean TEXT,
          kKPS0 TEXT,
          kKPS1 TEXT,
          kKSC0 TEXT,
          kKSC1 TEXT,
          kLau TEXT,
          kMainlandTelegraph TEXT,
          kMandarin TEXT,
          kMatthews TEXT,
          kMeyerWempe TEXT,
          kMorohashi TEXT,
          kNelson TEXT,
          kOtherNumeric TEXT,
          kPhonetic TEXT,
          kPrimaryNumeric TEXT,
          kPseudoGB1 TEXT,
          kRSAdobe_Japan1_6 TEXT,
          kRSJapanese TEXT,
          kRSKangXi TEXT,
          kRSKanWa TEXT,
          kRSKorean TEXT,
          kRSUnicode TEXT,
          kSBGY TEXT,
          kSemanticVariant TEXT,
          kSimplifiedVariant TEXT,
          kSpecializedSemanticVariant TEXT,
          kTaiwanTelegraph TEXT,
          kTang TEXT,
          kTotalStrokes TEXT,
          kTraditionalVariant TEXT,
          kVietnamese TEXT,
          kXerox TEXT,
          kXHC1983 TEXT,
          kZVariant TEXT
        )
      SQL

      connection.execute <<-SQL
        CREATE TABLE characters_variants (
          id INTEGER
            NOT NULL
            PRIMARY KEY
            AUTOINCREMENT,
          codepoint INTEGER
            NOT NULL
            REFERENCES characters (codepoint),
          kind text
            not null,
          variant_codepoint INTEGER
            NOT NULL
            REFERENCES characters (codepoint)
        )
      SQL

      connection.execute <<-SQL
        CREATE TABLE variant_sources (
          id INTEGER
            NOT NULL
            PRIMARY KEY,
          characters_variants_id INTEGER
            NOT NULL
            REFERENCES characters_variants (id),
          source TEXT
            NOT NULL
        )
      SQL
    end

    def self.codepoint_from_uplus(uplus)
      return uplus if uplus.is_a?(Fixnum)
      uplus.sub(/^U\+/, "").to_i(16)
    end
  end
end
