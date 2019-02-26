import { init } from './init'
import 'jquery-ui/ui/widgets/datepicker'
import 'jquery-ui/themes/base/theme.css'
import 'jquery-ui/themes/base/datepicker.css'

function initDatepicker(e, inserted = null) {
  $(inserted ? inserted : document).find('.datepicker').each(function () {
    $(this).datepicker()
  })
}

init(initDatepicker)