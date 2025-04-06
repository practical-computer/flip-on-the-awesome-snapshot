import { reflectColorPreference, setDefaultColorPreference } from '@practical-computer/practical-framework/js/util/theme-preference.js'

const defaultValue = document.firstElementChild.getAttribute(`data-default-theme`)
const customizedValue = document.firstElementChild.getAttribute(`data-theme`)

if(customizedValue){
  setColorPreference(customizedValue)
} else {
  setDefaultColorPreference(defaultValue)
}

reflectColorPreference()

console.debug("Legacy Theme Toggle Loaded")