module UnihanUtils
  # id, codepoint, relation, variant_codepoint
  class CharactersVariants < Base
    KINDS = %w(
      kCompatibilityVariant
      kSemanticVariant
      kSimplifiedVariant
      kSpecializedSemanticVariant
      kTraditionalVariant
      kZVariant
    )
    self.primary_key = :id
    belongs_to :character, class_name: "UnihanUtils::Character", foreign_key: :codepoint
    belongs_to :variant, class_name: "UnihanUtils::Character", foreign_key: :variant_codepoint
    has_many :sources, class_name: "UnihanUtils::VariantSource", primary_key: :id
    # define scope 'semantic_variants' etc..
    KINDS.each{|k|
      scope_name = k[1..-1].underscore.sub(/_variant$/, "")
      scope scope_name, -> { where(kind: k) }
    }

    def inspect
      "#{character.inspect} has #{kind.inspect}: #{variant.inspect}"
    end
  end
end
