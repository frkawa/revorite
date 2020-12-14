$(function (){
  // 各投稿のコメントボタンを押すとコメント欄を開く、または折り畳む
  $('.post-action__comment').click(function (){
    var post_id = $(this).attr('id').replace(/post-action__comment-/g, '');
    $('#comment_' + post_id).slideToggle();
  })
  
  // コメント投稿時に画像を選択すると画像のプレビューを表示する
  $('.comment-image-files').change(function (){
    var post_id = $(this).attr('id').replace(/-comment-images/g, '');
    $("#previewimages-" + post_id).html("");
    var filecount = this.files.length;

    // バリデーション：選択画像が4枚より多い場合はアラートを出して中断する
    if (filecount > 4){
      var cancelstr = '画像は一度に4枚まで投稿可能です';
      cancelupload(post_id, cancelstr);
      return;
    }
    
    for(i = 0; i < filecount; i++){
      // バリデーション：ファイル形式がjpeg, jpg, png以外の場合はアラートを出して中断する
      if (this.files[i].type != "image/jpeg" && this.files[i].type != "image/png") {
        var cancelstr = '画像はjpegまたはpng形式でアップロードしてください';
        cancelupload(post_id, cancelstr);
        return;
      }
      // バリデーション：3MBを超える画像を選択した場合はアラートを出して中断する
      if (this.files[i].size > 3145728) {
        var cancelstr = '画像は1ファイルにつき3MB以内にしてください';
        cancelupload(post_id, cancelstr);
        return;
      }
    }

    for(i = 0; i < filecount; i++){
      var reader = new FileReader();
      reader.name = this.files[i].name;

      $(reader).on("load", function (){
        $("<img>").appendTo("#previewimages-" + post_id)
        .prop({"src": this.result, "title": this.name});
      });

      if (this.files[i]) {
        reader.readAsDataURL(this.files[i]);
      }
    }

    // 画像を選択した時の画像枚数、文字数に応じてコメントボタンを活性/非活性化する
    buttononoff(post_id);
  })

  // コメント欄を入力の文字数に応じてコメントボタンが活性化される
  $(".comment-text").keyup(function (){
    var post_id = $(this).attr('id').replace(/comment-text/g, '');
    var textcount = $(this).val().length;
    $("#comment-textcount" + post_id).text(300 - textcount);

    // 文字を入力した時の文字数、画像枚数に応じてコメントボタンを活性/非活性化する
    buttononoff (post_id)
  })

  
  // buttononoff関数：コメントの入力文字数及び画像枚数より、コメントボタンを活性化/非活性化する
  function buttononoff (post_id) {
    var filecount = document.getElementById(post_id + "-comment-images").files.length;
    var textcount = $("#comment-text" + post_id).val().length;

    // 画像が1枚以上の場合はコメントが0文字以上300文字以下、
    // 画像が無い場合は1文字以上300文字以下ならボタンを活性化する。それ以外の時はボタンを非活性化する
    if (filecount >= 1){
      if (textcount >= 0 && textcount <= 300){
        $("#comment-button" + post_id).removeAttr('disabled');
      } else {
        $("#comment-button" + post_id).attr("disabled", true);
      }
    } else {
      if (textcount >= 1 && textcount <= 300){
        $("#comment-button" + post_id).removeAttr('disabled');
      } else {
        $("#comment-button" + post_id).attr("disabled", true);
      }
    }
  }

  // cancelupload関数：コメント投稿時に画像を選択した際、バリデーションチェックでNGの場合はアラートを出して画像選択を解除する
  function cancelupload(post_id, alertstr) {
    alert(alertstr);
    $("#" + post_id + "-comment-images").val('');
    $("#previewimages-" + post_id).html('');
    buttononoff(post_id);
  }
})
