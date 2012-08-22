require "unihan_utils/version"

module UnihanUtils
  require "unihan_utils/base"
  require "unihan_utils/character"
  require "unihan_utils/characters_variants"
  require "unihan_utils/import"
  require "unihan_utils/variant_source"
end

UnihanUtils::Base.init
