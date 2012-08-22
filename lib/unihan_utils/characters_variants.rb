module UnihanUtils
  # id, codepoint, relation, variant_codepoint
  class CharactersVariants < Base
    self.primary_key = :id
    belongs_to :character, class_name: "UnihanUtils::Character", foreign_key: :codepoint
    belongs_to :variant, class_name: "UnihanUtils::Character", foreign_key: :variant_codepoint
    has_many :sources, class_name: "UnihanUtils::VariantSource", primary_key: :id
  end
end
