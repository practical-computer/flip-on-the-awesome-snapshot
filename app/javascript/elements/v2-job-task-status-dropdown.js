const menuItemSelectedEvent = async function(event) {
  const dropdownElement = event.currentTarget
  const value = event.detail.item.value

  dropdownElement.form.elements["organization_job_task_status"].value = value
  dropdownElement.form.requestSubmit()
}

class JobTaskStatusDropdownElement extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    if(!this.isConnected){ return }

    this.addEventListener(`wa-select`, menuItemSelectedEvent)
  }

  get form() {
    return this.querySelector(`:scope form`)
  }

}

if (!window.customElements.get('job-task-status-dropdown')) {
  window.JobTaskStatusDropdownElement = JobTaskStatusDropdownElement;
  window.customElements.define('job-task-status-dropdown', JobTaskStatusDropdownElement);
}