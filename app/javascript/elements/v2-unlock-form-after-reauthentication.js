import {getReauthenticationToken} from '@practical-computer/practical-framework/js/handlers/passkey-reauthentication-handler';
import {submitFormEvent} from '@practical-computer/practical-framework/js/forms/registration-form';

async function unlockFormEvent(event) {
  let unlockButton = event.currentTarget
  let element = unlockButton.closest(`unlock-form-after-reauthentication`)

  await getReauthenticationToken(element.form)
  element.fieldsetToUnlock.removeAttribute(`disabled`)
}

class UnlockFieldsAfterReauthentication extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    if(!this.isConnected){ return }

    this.unlockButton.addEventListener(`click`, unlockFormEvent)
    this.form.addEventListener(`submit`, submitFormEvent)
  }

  get form() {
    return this.querySelector(`form`)
  }

  get unlockButton() {
    return this.querySelector(`[unlock-button]`)
  }

  get fieldsetToUnlock() {
    return this.querySelector(`[fieldset-to-unlock]`)
  }

}

if (!window.customElements.get('unlock-form-after-reauthentication')) {
  window.UnlockFieldsAfterReauthentication = UnlockFieldsAfterReauthentication;
  window.customElements.define('unlock-form-after-reauthentication', UnlockFieldsAfterReauthentication);
}