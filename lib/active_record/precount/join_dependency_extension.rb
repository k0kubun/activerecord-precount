module ActiveRecord
  module Precount
    module JoinDependencyExtension
      class CountTable < Associations::JoinDependency::Aliases::Table
        def column_aliases
          columns.map { |column| table[column.name].count.as Arel.sql column.alias }
        end
      end

      def aliases
        Associations::JoinDependency::Aliases.new join_root.each_with_index.map { |join_part,i|
          if join_part.is_a?(Associations::JoinDependency::JoinAssociation) && join_part.reflection.macro == :count_loader
            # select COUNT(primary_key)
            column_name = join_part.reflection.klass.primary_key
            column = Associations::JoinDependency::Aliases::Column.new column_name, "t#{i}_r0"
            CountTable.new(join_part, [column])
          else
            # original aliases' internal function
            columns = join_part.column_names.each_with_index.map { |column_name,j|
              Associations::JoinDependency::Aliases::Column.new column_name, "t#{i}_r#{j}"
            }
            Associations::JoinDependency::Aliases::Table.new(join_part, columns)
          end
        }
      end

      private

      # instantiate only count_loader and pass others to super
      def construct(ar_parent, parent, row, rs, seen, model_cache, aliases)
        normal_children = []

        parent.children.each do |node|
          if node.reflection.macro != :count_loader
            normal_children << node
            next
          end

          key = aliases.column_alias(node, node.primary_key)
          ar_parent.association(node.reflection.name).target = row[key].to_i
        end
        return if normal_children.blank?

        normal_parent = Associations::JoinDependency::JoinBase.new(parent.base_klass, normal_children)
        super(ar_parent, normal_parent, row, rs, seen, model_cache, aliases)
      end
    end
  end
end
