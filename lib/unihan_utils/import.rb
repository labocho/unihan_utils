require "csv"

module UnihanUtils
  module Import
    DATA_DIR = "#{File.dirname(__FILE__)}/../../data"
    module_function
    def variants
      path = "#{DATA_DIR}/Unihan_Variants.txt"

      STDERR.puts "Delete CharactersVariants..."
      CharactersVariants.delete_all
      STDERR.puts "Delete VariantSource..."
      VariantSource.delete_all

      open(path, "r") do |f|
        # skip comment lines
        while true
          line = f.readline
          next if line =~ /^#/
          break f.pos -= line.bytesize # rewind for last line
        end

        CSV.new(f, col_sep: "\t").each do |row|
          # row: ["U+3943", "kSemanticVariant", "U+60B6<kMatthews,kMeyerWempe U+61E3<kMatthews"]
          codepoint, relation, variants = row
          break unless codepoint

          character = Character.create_or_find_by_codepoint_uplus(codepoint)

          variants.split(" ").each do |variant_and_sources|
            # variant_and_sources: "U+60B6<kMatthews,kMeyerWempe"
            variant_codepoint, sources_string = variant_and_sources.split("<")

            # sources_string: "kMatthews,kMeyerWempe"
            sources = if sources_string
              sources_string.split(",")
            else
              []
            end

            # Create variant
            variant = Character.create_or_find_by_codepoint_uplus(variant_codepoint)
            cv = character.characters_variants.build(variant: variant, relation: relation)
            cv.save!
            STDERR.puts "CharactersVariants created: #{cv.inspect}"

            # Create sources
            sources.each do |source|
              s = cv.sources.build(source: source)
              s.save!
              STDERR.puts "VariantSource created: #{s.inspect}"
            end
          end
        end
      end
    end
  end
end
