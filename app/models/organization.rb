# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :membership_invitations, dependent: :destroy
  has_many :memberships, dependent: :destroy, class_name: "::Membership"
  has_many :users, through: :memberships
  has_many :attachments, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :onsites, through: :jobs
  has_many :job_tasks, through: :jobs, source: :tasks
end
