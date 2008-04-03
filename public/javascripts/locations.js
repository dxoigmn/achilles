$(document).ready(function() { 
  $('a.remove').click(function() {
    $(this).parents('.subnet').remove();
    return false;
  })
})