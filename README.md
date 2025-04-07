# Flip On The Awesome Snapshot


This repo is the companion to [Flip On The Awesome: A guide to overhauling a Rails app view layer]().

## What is Dispatcher?

It is an app Practical Computer was commissioned to write, which I use as testbed. This is a snapshot of the app right when I turned on the alpha for the Web Awesome UI, to act as a public resource for folks to study.

It’s a simple job and onsite management tool for service companies. The office specifies a job, the tasks it requires, sets up onsites, and assigns tasks to those onsites. Onsites can have notes attached to them. Your standard states & priority flags apply as well.

## Focus areas

I recommend focusing on the following places in the repo:

* The original set of Phlex components
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/tree/main/app/components
* The new set of ViewComponents
  https://github.com/practical-computer/flip-on-the-awesome-snapshot/tree/main/app/views/components
* The base `PrascticalViews::IconSet` and `ApplicationIconSet`
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/blob/main/app/lib/practical_views/icon_set.rb
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/blob/main/app/lib/application_icon_set.rb
* Setting up Web Awesome style utility concerns & abstractions for ViewComponents
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/tree/main/app/lib/practical_views/web_awesome/style_utility
* The `FormBuilder` extended to support Web Awesome & detailed error rendering
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/blob/main/app/lib/practical_views/form_builders/web_awesome.rb
* An example of adapting tests based on if the suite is running against the Web Awesome UI
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/blob/main/test/system/organizations/jobs_test.rb
* `app/javascript` and `app/assets/stylesheets`, which have split entry points to avoid code collisions
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/tree/main/app/javascript
  * https://github.com/practical-computer/flip-on-the-awesome-snapshot/tree/main/app/assets/stylesheets