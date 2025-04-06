# frozen_string_literal: true

# Add code here to build the data you need for your edge case test!
# It'll only be loaded when you specifically seed the case; keeping your test data clean

register Organization::Note

def organization_notes.create_labeled(label, author:, organization:, resource:, tiptap_document:)
  create(label, original_author: author,
                organization: organization,
                resource: resource,
                tiptap_document: tiptap_document
        )
end


organization_notes.create_labeled(:organization_1_note,
                                  organization: organizations.organization_1,
                                  author: users.organization_1_department_head,
                                  resource: organization_jobs.repeat_customer,
                                  tiptap_document: {type: "doc", content: [{type: "text", contents: SecureRandom.hex}]}
)

organization_notes.create_labeled(:organization_2_note,
                                  organization: organizations.organization_2,
                                  author: users.organization_2_owner,
                                  resource: organization_jobs.new_customer_organization_2,
                                  tiptap_document: {type: "doc", content: [{type: "text", contents: SecureRandom.hex}]}
)