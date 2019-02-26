import { init } from './init'
import 'select2'

export function select2(element, options = {}) {
  let tags = element.data('select-tags') || false
  element.select2({
    theme: 'bootstrap4',
    tags,
    minimumResultsForSearch: 10,
    ...options
  })
}

function buildSelect2(e, inserted = null) {
  $(inserted ? inserted : document).find('select').not('.native').each(function() {
    select2($(this))
  })
}

export default function initSelect2() { init(buildSelect2) }
