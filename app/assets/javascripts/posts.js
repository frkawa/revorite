$(function (){
  $('.post-action__comment').click(function (){
    var post_id = $(this).attr('id').replace(/post-action__comment-/g, '');
    $('#comment_' + post_id).slideToggle();
  })
})