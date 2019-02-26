$(function () {
  // auto-hides any Rails flash notices after 2 sec
  const alerts = $('.app-flash-alert'),
    spacer = alerts.siblings('.invisible')
  alerts.delay('2000').slideUp()
  spacer.delay('2000').slideUp()
})