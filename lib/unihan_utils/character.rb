module UnihanUtils
  # http://www.unicode.org/reports/tr38/#N10260
  class Character < Base
    self.primary_key = :codepoint

    has_many :characters_variants, class_name: "UnihanUtils::CharactersVariants", foreign_key: :codepoint
    has_many :variants, class_name: "UnihanUtils::Character", through: :characters_variants
    # define scope 'semantic_variants' etc..
    CharactersVariants::KINDS.each{|k|
      scope_name = k[1..-1].underscore.pluralize
      has_many "characters_#{scope_name}".to_sym, -> { where(kind: k) }, class_name: "UnihanUtils::CharactersVariants", foreign_key: :codepoint
      has_many scope_name.to_sym, class_name: "UnihanUtils::Character", through: "characters_#{scope_name}", source: :variant
    }

    attr_readonly :codepoint

    def self.build_from_codepoint(codepoint)
      new(codepoint: codepoint_from_uplus(codepoint))
    end

    def self.from_string(s)
      s.codepoints.map{|c| find_by_codepoint(c) }
    end

    def self.find_by_string(s)
      find_by_codepoint(s[0].codepoints.first)
    end

    def self.create_or_find_by_codepoint(codepoint)
      codepoint = codepoint_from_uplus(codepoint)
      unless c = find_by_codepoint(codepoint)
        c = new(codepoint: codepoint)
        c.save!
        STDERR.puts "Character created: #{c.inspect}"
      end
      c
    end

    def to_s
      codepoint.chr Encoding::UTF_8
    end

    def inspect
      "\"#{to_s}\" (#{uplus})"
    end

    def uplus
      "U+#{codepoint.to_s(16).upcase.rjust(4, "0")}"
    end

    # Space delimited field
    %w(kCantonese kCCCII kCheungBauer kCheungBauerIndex
       kCihaiT kCowles kFenn kFennIndex kFourCornerCode
       kGSR kHangul kHanYu kHanyuPinlu kHanyuPinyin kHKGlyph
       kJapaneseKun kJapaneseOn kKorean kLau kMandarin
       kMeyerWempe kMorohashi kNelson kPhonetic kRSAdobe_Japan1_6
       kRSJapanese kRSKangXi kRSKanWa kRSKorean kRSUnicode
       kSBGY kSemanticVariant kSimplifiedVariant
       kSpecializedSemanticVariant kTang kTraditionalVariant
       kVietnamese kXHC1983 kZVariant).each do |column|
      method_name = column[1..-1].underscore
      define_method method_name do
        return unless self[column]
        self[column].split(" ")
      end
    end

    # Numeric field
    %w(kAccountingNumeric kOtherNumeric kPrimaryNumeric
       kFrequency kGradeLevel).each do |column|
      method_name = column[1..-1].underscore
      define_method method_name do
        return unless self[column]
        self[column].to_i
      end
    end

    # Space delimited numeric field
    %w(kTotalStrokes).each do |column|
      method_name = column[1..-1].underscore
      define_method method_name do
        return unless self[column]
        self[column].split.map(&:to_i)
      end
    end

    # Simple string field
    column_names.each do |column|
      next if column == "codepoint"
      method_name = column[1..-1].underscore
      next if instance_methods.include?(method_name.to_sym)
      define_method method_name do
        self[column]
      end
    end
  end
end
