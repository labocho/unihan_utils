module UnihanUtils
  class Character < Base
    self.primary_key = :codepoint

    has_many :characters_variants, class_name: "UnihanUtils::CharactersVariants", foreign_key: :codepoint
    has_many :variants, class_name: "UnihanUtils::Character", through: :characters_variants

    attr_accessible :codepoint
    attr_readonly :codepoint

    def self.build_from_uplus(uplus)
      new(codepoint: codepoint_from_uplus(uplus))
    end

    def self.from_string(s)
      s.codepoints.map{|c| find_by_codepoint(c) }
    end

    def self.create_or_find_by_codepoint(codepoint)
      unless c = find_by_codepoint(codepoint)
        c = new(codepoint: codepoint)
        c.save!
        STDERR.puts "Character created: #{c.inspect}"
      end
      c
    end

    def self.create_or_find_by_codepoint_uplus(uplus)
      create_or_find_by_codepoint codepoint_from_uplus(uplus)
    end

    def to_s
      codepoint.chr Encoding::UTF_8
    end
  end
end
