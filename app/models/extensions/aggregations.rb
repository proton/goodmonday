# coding: utf-8

module Extensions
  module Aggregations
    extend ActiveSupport::Concern

    module ClassMethods
      def group_by(key_field, opts = {})
        pipeline = []

        #matching
        if opts[:cond] && !opts[:cond].empty?
          pipeline << {"$match" => opts[:cond]}
        end

        #grouping
        h = {}
        h['_id'] = "$#{key_field.to_s}"
        agregation_methods = [:first, :last, :max, :mix, :avg, :sum, :push] #http://docs.mongodb.org/manual/reference/aggregation/group/#_S_group
        agregation_methods.each do |method|
          if opts[method]
            opts[method].each do |field|
              field = field.to_s
              h["#{field}_#{method}"] = {"$#{method}" => "$#{field}"}
            end
          end
        end
        pipeline << {"$group" => h}

        #sorting
        h = {}
        if opts[:sort_asc]
          opts[:sort_asc].each do |field|
            h[field.to_s] = 1
          end
        end
        if opts[:sort_desc]
          opts[:sort_desc].each do |field|
            h[field.to_s] = -1
          end
        end
        unless h.empty?
          pipeline << {"$sort" => h}
        end

        #puts pipeline

        collection.aggregate(pipeline)
      end
    end
  end
end