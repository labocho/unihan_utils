require "unihan_utils/version"

module UnihanUtils
  autoload :Base, "unihan_utils/base"
  autoload :Character, "unihan_utils/character"
  autoload :CharactersVariants, "unihan_utils/characters_variants"
  autoload :Import, "unihan_utils/import"
  autoload :VariantSource, "unihan_utils/variant_source"
end

UnihanUtils::Base.init
