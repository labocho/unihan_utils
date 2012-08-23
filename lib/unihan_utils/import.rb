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

      each_row(path) do |row|
        # row: ["U+3943", "kSemanticVariant", "U+60B6<kMatthews,kMeyerWempe U+61E3<kMatthews"]
        codepoint, kind, variants = row

        character = Character.create_or_find_by_codepoint(codepoint)

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
          variant = Character.create_or_find_by_codepoint(variant_codepoint)
          cv = character.characters_variants.build(variant: variant, kind: kind)
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

    def characters
      Character.delete_all
      Dir.glob("#{DATA_DIR}/Unihan_*.txt") do |path|
        STDERR.puts "Importing: #{path}"
        each_row(path) do |row|
          codepoint, column, value = row
          character = Character.create_or_find_by_codepoint(codepoint)
          raise "Duplicate entry: #{row.inspect}" if character[column]
          character[column] = value
          character.save!
          STDERR.puts "Character updated: {#{column}: #{value.inspect}}"
        end
      end
    end

    def each_row(path)
      open(path, "r") do |f|
        # skip comment lines
        while true
          line = f.readline
          next if line =~ /^#/
          break f.pos -= line.bytesize # rewind for last line
        end

        CSV.new(f, col_sep: "\t").each do |row|
          break if row.empty?
          yield row
        end
      end
    end
  end
end
