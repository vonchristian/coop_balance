# config/initializers/ancestry.rb

# use the newer format
Ancestry.default_ancestry_format = :materialized_path2
Ancestry.default_primary_key_format = '[\w-]{36}'