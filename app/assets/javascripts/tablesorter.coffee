$(document).on 'turbolinks:load', ->
  $('table:not(.nosort)').tablesorter({
    theme: 'blue',

    headers:{
      '.nosort':{
        sorter: false,
        filter: false
      }
    },

    emptyTo: 'min',
    stringTo: 'max',


    initWidgets: true,

    widgets: ['zebra', 'columns', 'filter', 'stickyHeaders', 'resizable']


  })
