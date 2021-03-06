# frozen_string_literal: true

require_relative "helper"

module Arel
  class DeleteManagerTest < Arel::Spec
    describe "new" do
      it "takes an engine" do
        Arel::DeleteManager.new
      end
    end

    it "handles limit properly" do
      table = Table.new(:users)
      dm = Arel::DeleteManager.new
      dm.take 10
      dm.from table
      dm.key = table[:id]
      assert_match(/LIMIT 10/, dm.to_sql)
    end

    describe "from" do
      it "uses from" do
        table = Table.new(:users)
        dm = Arel::DeleteManager.new
        dm.from table
        dm.to_sql.must_be_like %{ DELETE FROM "users" }
      end

      it "chains" do
        table = Table.new(:users)
        dm = Arel::DeleteManager.new
        dm.from(table).must_equal dm
      end
    end

    describe "where" do
      it "uses where values" do
        table = Table.new(:users)
        dm = Arel::DeleteManager.new
        dm.from table
        dm.where table[:id].eq(10)
        dm.to_sql.must_be_like %{ DELETE FROM "users" WHERE "users"."id" = 10}
      end

      it "chains" do
        table = Table.new(:users)
        dm = Arel::DeleteManager.new
        dm.where(table[:id].eq(10)).must_equal dm
      end
    end

    describe "comment" do
      it "chains" do
        manager = Arel::DeleteManager.new
        manager.comment("deleting").must_equal manager
      end

      it "appends a comment to the generated query" do
        table = Table.new(:users)
        dm = Arel::DeleteManager.new
        dm.from table
        dm.comment("deletion")
        assert_match(%r{DELETE FROM "users" /\* deletion \*/}, dm.to_sql)

        dm.comment("deletion", "with", "comment")
        assert_match(%r{DELETE FROM "users" /\* deletion \*/ /\* with \*/ /\* comment \*/}, dm.to_sql)
      end
    end
  end
end
