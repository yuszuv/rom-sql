module ROM
  module Plugins
    module Relation
      module SQL
        module Postgres
          # PG-specific extensions which adds `Relation#full_text_search` method
          #
          # @api public
          module PgTrgm

            def full_text_search(*args)
              new(dataset.full_text_search(*args))
            end

          end
        end
      end
    end
  end
end

ROM.plugins do
  adapter :sql do
    register :pg_trgm, ROM::Plugins::Relation::SQL::Postgres::PgTrgm, type: :relation
  end
end
