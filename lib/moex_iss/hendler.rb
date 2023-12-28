# frozen_string_literal: true

module MoexIss
  module Hendler
    def handle_response(response)
      return standard_hendler(response) if standard_schema?(response)

      fail MoexIss::Error::ResponseSchemaError, "Неизвестная схема ответа"
    end

    private

    def standard_schema?(response)
      response.is_a?(Array) &&
        response[1]&.keys == %w[securities marketdata] &&
        response[1]["securities"].is_a?(Array) &&
        response[1]["marketdata"].is_a?(Array)
    end

    def standard_hendler(response)
      response[1]["securities"].map.with_index do |x, i|
        {"securities" => x, "marketdata" => response[1]["marketdata"][i]}
      end
    end
  end
end
