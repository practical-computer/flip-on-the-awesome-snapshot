# frozen_string_literal: true

# rubocop:disable Layout/LineLength
require 'faker'
organization = organizations.koepp_inc

lucinda = users.lucinda

class TiptapDocument
  extend PracticalFramework::TestHelpers::TiptapDocumentHelpers
end

def generate_document(sentences:)
  TiptapDocument.example_quick_note(sentences: Array.wrap(sentences))
end

def create_job(label:, organization: organizations.koepp_inc, **)
  organization_jobs.create_labeled(label, organization: organization, **)
end

def create_onsite(seed_label, label:, job:, original_creator: users.lucinda, **)
  organization_onsites.create_labeled(seed_label, label: label, job: job, original_creator: original_creator, **)
end

def create_task(seed_label, job:, onsite:, original_creator: users.lucinda, **)
  organization_job_tasks.create_labeled(seed_label, job: job, onsite: onsite, original_creator: original_creator, **)
end

section :switch_not_working_job do
  switch_not_working_job = create_job(label: :switch_not_working_job,
                                      name: "Gibson and Sons",
                                      google_place: google_places.library,
                                      original_creator: lucinda
  )

  if switch_not_working_job.note.blank?
    switch_not_working_job.create_note!(
      tiptap_document: generate_document(sentences: "3 way switch not working properly, possibly due to wrong wiring."),
      organization: organization,
      original_author: lucinda
    )
  end

  create_task(:troubleshoot_3_way_wire,
              label: "Troublesheet 3 way wire",
              job: switch_not_working_job,
              onsite: nil,
              status: :todo,
              estimated_minutes: 60
            )

  create_task(:ask_for_review,
              label: "Ask for a review",
              job: switch_not_working_job,
              onsite: nil,
              status: :todo,
              estimated_minutes: 30
            )
end

section :install_and_recycle_job do
  install_and_recycle_job = create_job(label: :install_and_recycle_job,
                                       name: "Simonis-Mayert",
                                       google_place: google_places.library_2,
                                       original_creator: lucinda
  )

  if install_and_recycle_job.note.blank?
    install_and_recycle_job.create_note!(
      tiptap_document: generate_document(sentences: [
                                         "Store reports: (60) 4ft T8 41k lamps are on site. Please us ALL lamps that are on site and use any remaining lamps to repair lights with blackened ends/end of life.",
                                         "No good material is to be left on site. Please call D'Amore Group if there are lamps or ballasts left over."
                                         ]),
      organization: organization,
      original_author: lucinda
    )
  end

  create_task(:install_t8_lamps,
              label: "Install 60 4ft T8 41k lamps",
              job: install_and_recycle_job,
              onsite: nil,
              status: :todo,
              estimated_minutes: 120
            )

  create_task(:recycle_lamps,
              label: "Recycle 4' Lamps",
              job: install_and_recycle_job,
              onsite: nil,
              status: :done,
              estimated_minutes: 45
            )
end

section :fix_light_ballast_job do
  fix_light_ballast_job = create_job(label: :fix_light_ballast_job,
                                     name: "Krajcik Group",
                                     google_place: google_places.library_3,
                                     original_creator: lucinda,
  )

  if fix_light_ballast_job.note.blank?
    fix_light_ballast_job.create_note!(
      tiptap_document: generate_document(sentences: [
                                         "Hanging lights in the aquatic area are out, they have already tried to replace light bulbs, but think it's a ballast issue.",
                                         "If time and supplies exceed allotted NTE please call Christiansen-Heaney."
                                         ]),
      organization: organization,
      original_author: lucinda
    )
  end

  ballast_onsite = create_onsite(:ballast_onsite,
                                 label: "Ballast inspection",
                                 job: fix_light_ballast_job,
                                 status: :in_progress,
                                 priority: :high_priority
                                )

  create_task(:troubleshoot_ballasts,
              label: "Troubleshoot lights and ballasts",
              job: fix_light_ballast_job,
              onsite: ballast_onsite,
              status: :done,
              estimated_minutes: 10
            )
end

section :sign_replacement_job do
  sign_replacement_job = create_job(label: :sign_replacement,
                                    name: "Toy, Welch and Hills",
                                    google_place: google_places.post_office,
                                    original_creator: lucinda
  )

  inspection_onsite = create_onsite(:inspection_onsite,
                                    label: "Inspect current signs",
                                    job: sign_replacement_job,
                                    status: :done,
                                  )

  if inspection_onsite.notes.empty?
    inspection_onsite.notes.create!(
      tiptap_document: generate_document(sentences: "Need to replace all signs on site."),
      organization: organization,
      original_author: lucinda
    )
  end

  create_task(:inspect_signs,
              label: "Inspect signs",
              job: sign_replacement_job,
              onsite: inspection_onsite,
              status: :done,
              estimated_minutes: 30
            )

  create_task(:order_signs,
              label: "Order signs from supplier",
              onsite: nil,
              job: sign_replacement_job,
              task_type: :offsite,
              status: :done
  )

  replacement_onsite = create_onsite(:replacement_onsite,
                                     label: "Replace signs",
                                     job: sign_replacement_job,
                                     status: :scheduled
                                    )

  if replacement_onsite.notes.empty?
    replacement_onsite.notes.create!(
      tiptap_document: generate_document(sentences: "Return to site with supplied material to complete repairs to 6 exit signs."),
      organization: organization,
      original_author: lucinda
    )
  end

  create_task(:replace_exit_signs,
              label: "Replace 6 exit signs",
              job: sign_replacement_job,
              onsite: replacement_onsite
  )
end

section :power_pack_replacement_job do
  power_pack_replacement_job = create_job(label: :power_pack_replacement_job,
                                          name: "Heaney Group",
                                          google_place: google_places.library_4,
                                          original_creator: lucinda
  )

  if power_pack_replacement_job.note.blank?
    power_pack_replacement_job.create_note!(
      tiptap_document: generate_document(sentences: [
                                         "Return and replace the OPP20-D1 power pack and OSC20-M0W sensor located in the framing dept using material that has been sent to site.",
                                         "If additional time/materials are needed to complete the same day, call Schumm-Berge."
                                         ]),
      organization: organization,
      original_author: lucinda
    )
  end

  create_task(:replace_power_pack,
              label: "Replace OPP20-D1 Power Pack",
              job: power_pack_replacement_job,
              onsite: nil,
              estimated_minutes: 80
  )

  create_task(:replace_sensor,
              label: "Replace OSC20-M0W Sensor",
              job: power_pack_replacement_job,
              onsite: nil,
              estimated_minutes: 40,
              status: :done
  )
end

section :checkin_job do
  checkin_job = create_job(label: :checkin_job,
                           name: "Batz-Casper",
                           google_place: google_places.library_5,
                           original_creator: lucinda
  )

  if checkin_job.note.blank?
    checkin_job.create_note!(
      tiptap_document: generate_document(sentences: [
                                         "Monthly check in"
                                         ]),
      organization: organization,
      original_author: lucinda
    )
  end

  create_task(:checkin_call,
              label: "Call",
              job: checkin_job,
              onsite: nil,
              status: :done,
              task_type: :offsite
  )
end

# rubocop:enable Layout/LineLength