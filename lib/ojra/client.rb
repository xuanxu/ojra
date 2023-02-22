require 'faraday'

module OJRA
  class Client
    attr_reader :host_url, :token, :error_msg

    def initialize(host_url, token)
      @host_url = host_url.to_s.strip
      @token = token.to_s.strip
      @error_msg = nil
    end

    def configured?
      !(host_url.empty? || token.empty?)
    end

    def assign_reviewer(reviewer, issue_id, api_action="review_assigned")
      set_error_msg("Missing value: reviewer") and return if reviewer.to_s.strip.empty?

      url = "#{host_url}/api/stats/update/#{reviewer}/#{api_action}"
      idempotency_key = "assign-#{reviewer}-#{issue_id}"

      reviewers_api_post(url, { idempotency_key: idempotency_key })
    end

    def unassign_reviewer(reviewer, issue_id, api_action="review_unassigned")
      set_error_msg("Missing value: reviewer") and return if reviewer.to_s.strip.empty?

      url = "#{host_url}/api/stats/update/#{reviewer}/#{api_action}"
      idempotency_key = "unassign-#{reviewer}-#{issue_id}"

      reviewers_api_post(url, { idempotency_key: idempotency_key })
    end

    def assign_reviewers(reviewers, issue_id)
      reviewers_list = get_list(reviewers)
      reviewers_list.each { |reviewer| assign_reviewer(reviewer, issue_id) }
    end

    def unassign_reviewers(reviewers, issue_id)
      reviewers_list = get_list(reviewers)
      reviewers_list.each { |reviewer| unassign_reviewer(reviewer, issue_id) }
    end

    def start_review(reviewers, issue_id)
      reviewers_list = get_list(reviewers)
      reviewers_list.each { |reviewer| assign_reviewer(reviewer, issue_id, "review_started") }
    end

    def finish_review(reviewers, issue_id)
      reviewers_list = get_list(reviewers)
      reviewers_list.each { |reviewer| unassign_reviewer(reviewer, issue_id, "review_finished") }
    end

    private

    def unconfigured_api
      raise UnconfiguredAPI.new("Missing configuration values for the API: host's URL and/or API Token")
    end

    def set_error_msg(message)
      @error_msg = message
    end

    def get_list(items)
      items_list = []
      if items.is_a?(String)
        items_list = items.split(',').each(&:strip!)
      elsif items.is_a?(Array)
        items_list = items.each(&:strip!)
      end
      items_list
    end

    def reviewers_api_post(url, params)
      unconfigured_api unless configured?

      response = Faraday.post(url, params, { "TOKEN" => token })

      if response.status.between?(400, 599)
        set_error_msg("Error response code from #{url}: #{response.status}")
      end

      response.status.between?(200, 299)
    end
  end
end