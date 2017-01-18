require 'dry-types'
require 'sequel'
require 'ipaddr'

Sequel.extension(*%i(pg_array pg_array_ops pg_json pg_json_ops))

module ROM
  module SQL
    module Types
      module PG
        # UUID

        UUID = Types::String

        # Array

        Array = Dry::Types::Definition
                .new(Sequel::Postgres::PGArray)

        def self.Array(db_type)
          Array.constructor(-> (v) { Sequel.pg_array(v, db_type) }).meta(type: db_type)
        end

        # JSON

        JSONArray = Types.Constructor(Sequel::Postgres::JSONArray, &Sequel.method(:pg_json))

        JSONHash = Types.Constructor(Sequel::Postgres::JSONArray, &Sequel.method(:pg_json))

        JSONOp = Types.Constructor(Sequel::Postgres::JSONOp, &Sequel.method(:pg_json))

        JSON = JSONArray | JSONHash | JSONOp

        # JSONB

        JSONBArray = Types.Constructor(Sequel::Postgres::JSONBArray, &Sequel.method(:pg_jsonb))

        JSONBHash = Types.Constructor(Sequel::Postgres::JSONBHash, &Sequel.method(:pg_jsonb))

        JSONBOp = Types.Constructor(Sequel::Postgres::JSONBOp, &Sequel.method(:pg_jsonb))

        JSONB = JSONBArray | JSONBHash | JSONBOp

        Bytea = Types.Constructor(Sequel::SQL::Blob, &Sequel::SQL::Blob.method(:new))

        IPAddressR = Types.Constructor(IPAddr) { |ip| IPAddr.new(ip.to_s) }

        IPAddress = Types.Constructor(IPAddr, &:to_s).meta(read: IPAddressR)

        Money = Types::Decimal

        Point = ::Struct.new(:x, :y)

        PointTR = Types.Constructor(Point) do |p|
          x, y = p.to_s[1...-1].split(',', 2)
          Point.new(Float(x), Float(y))
        end

        PointT = Types.Constructor(Point) { |p| "(#{ p.x },#{ p.y })" }.meta(read: PointTR)
      end
    end
  end
end
