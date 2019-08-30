import './images'
import 'jquery-ujs'
import '@fortawesome/fontawesome-pro/js/all.js'
import 'bootstrap'
import './flash-alerts-animation'
import LocalTime from "local-time"
import './cocoon.js.erb'
import initSelect2 from './init-select2'
import './datepicker'
import axios from 'axios'

// axios defaults
axios.defaults.headers.common['Accept'] = 'application/json';
const tokenDom = document.querySelector("meta[name=csrf-token]")
if (tokenDom) {
  const csrfToken = tokenDom.content
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken
}

LocalTime.start()
initSelect2()
