// utility function to initialize jQuery libraries
// on document ready
// AND
// cocoon.js [after-insert] event
function init(fn) {
  $(document).on('cocoon:after-insert', fn)
  $(fn)
}

export {
  init
}
