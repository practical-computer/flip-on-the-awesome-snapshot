import { setColorPreference, reflectColorPreference, setDefaultColorPreference } from './vendor/practical-framework/util/v2-theme-preference'

const defaultValue = document.firstElementChild.getAttribute(`data-default-theme`)
const customizedValue = document.firstElementChild.getAttribute(`data-theme`)

if(customizedValue){
  setColorPreference(customizedValue)
} else {
  setDefaultColorPreference(defaultValue)
}

reflectColorPreference()
