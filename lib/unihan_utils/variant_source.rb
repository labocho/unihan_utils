module UnihanUtils
  # id, characters_variants_id, source
  class VariantSource < Base
    belongs_to :characters_variants, class_name: "UnihanUtils::CharactersVariants", primary_key: :id

    def inspect
      "#{source.inspect} describes variant (#{characters_variants.inspect})"
    end
  end
end
