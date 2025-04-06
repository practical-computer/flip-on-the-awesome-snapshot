# frozen_string_literal: true

class Organization::Jobs::OnsitesSummaryComponent < Phlex::HTML
  attr_accessor :job, :statuses

  def initialize(job:, statuses: Organization::Onsite.statuses.keys)
    self.job = job
    self.statuses = statuses
  end

  def view_template
    section(class: tokens("cluster-compact")) {
      counts.each do |status, count|
        render CountBadge.new(status: status, count: count)
      end
    }
  end

  def counts
    self.job.onsites.where(status: statuses).group(:status).count
  end

  class CountBadge < Phlex::HTML
    attr_accessor :status, :count

    def initialize(status:, count:)
      self.status = status
      self.count = count
    end

    def view_template
      span(class: tokens("badge labeled-badge compact-size rounded onsite-status-badge", status), title: title) {
        unsafe_raw helpers.onsite_status_icon(status: status)
        whitespace
        plain count
      }
    end

    def title
      helpers.pluralize(count, helpers.human_onsite_status(status: status))
    end
  end
end