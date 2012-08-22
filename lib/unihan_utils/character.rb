module UnihanUtils
  class Character < Base
    self.primary_key = :codepoint

    has_many :characters_variants, class_name: "UnihanUtils::CharactersVariants", foreign_key: :codepoint
    has_many :variants, class_name: "UnihanUtils::Character", through: :characters_variants
    # define scope 'semantic_variants' etc..
    CharactersVariants::RELATION.each{|r|
      scope_name = r[1..-1].underscore.pluralize
      has_many "characters_#{scope_name}", class_name: "UnihanUtils::CharactersVariants", foreign_key: :codepoint, conditions: {relation: r}
      has_many scope_name, class_name: "UnihanUtils::Character", through: "characters_#{scope_name}", source: :variant
    }

    attr_accessible :codepoint
    attr_readonly :codepoint

    def self.build_from_codepoint(codepoint)
      new(codepoint: codepoint_from_uplus(codepoint))
    end

    def self.from_string(s)
      s.codepoints.map{|c| find_by_codepoint(c) }
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
  end
end
