module UnihanUtils
  # id, codepoint, relation, variant_codepoint
  class CharactersVariants < Base
    RELATION = %w(
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
    RELATION.each{|r|
      scope_name = r[1..-1].underscore.sub(/_variant$/, "")
      scope scope_name, where(relation: r)
    }

    def inspect
      "#{character.inspect} has #{relation.inspect}: #{variant.inspect}"
    end
  end
end
