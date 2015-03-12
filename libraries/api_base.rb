#
# Cookbook Name:: serverdensity
# Library:: api-base

module ServerDensity
  module API

    module Base
      attr_reader :version

      protected

      def delete(path, *args, &block)
        request :delete, path, nil, *args, &block
      end

      def get(path, *args, &block)
        request :get, path, nil, *args, &block
      end

      def post(path, *args, &block)
        request :post, path, *args, &block
      end

      def put(path, *args, &block)
        request :put, path, *args, &block
      end

      def base_url
        nil
      end

      def params(value = nil)
        @params ||= {}
        if value.nil?
          @params
        else
          @params.merge! value
        end
      end

      def validate(meta, default = {})
        meta.each do |k, v|
          default.update(k.to_sym => v)
        end unless meta.nil?
        default
      end

      private

      def request(method, path, payload, options = {}, &block)
        require 'rest-client'

        options[:params] = if options.has_key? :params
          params.merge(options[:params])
        else
          params
        end

        req = { method: method, url: "#{base_url}#{path}", headers: options }
        req[:payload] = payload if [:patch, :post, :put].include? method

        begin
          response(RestClient::Request.execute(req, &block))
        rescue => err
          raise err.class.new(response(err.response), err.http_code)
        end
      end

      def response(res)
        require 'rest-client'

        body = Chef::JSONCompat.from_json(res)
        RestClient::Response.create(body, res.net_http_res, res.args)
      end
    end

  end
end
