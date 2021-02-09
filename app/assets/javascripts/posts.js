$(function (){
  // 新規投稿画面 START -------------------------------------------------------------------------------------------------------------
  // 「レビューをする」をチェックするとレビューに必要な入力項目を表示する、チェックを外すと隠す
  $("#newpost-rev_flg").change(function (){
    $(".newpost-items__review").slideToggle('fast');
  })

  // レビュー対象が入力・変更された時、バリデーションチェックを行う
  $("#newpost-input-title").change(function (){
    title_check();
  })

  
  // 新規投稿画面 END ---------------------------------------------------------------------------------------------------------------


  // 各投稿のコメントボタンを押すとコメント欄を開く、または折り畳む
  $(document).on("click", ".post-action__comment", function(){
    var post_id = $(this).attr('id').replace(/post-action__comment-/g, '');
    $('#comment_' + post_id).slideToggle('fast');
  })
  
  // コメント投稿時に画像を選択すると画像のプレビューを表示する
  $(document).on("change", ".comment-image-files", function(){
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

    // 画像を選択した時の画像枚数、コメント欄文字数に応じてコメントボタンを活性/非活性化する
    buttononoff(post_id);
  })

  // コメント欄で文字入力する度にイベント発生
  $(document).on("keyup", ".comment-text", function(){
    var post_id = $(this).attr('id').replace(/comment-text/g, '');
    var textcount = $(this).val().length;
    // 残り入力可能文字数を更新する
    $("#comment-textcount" + post_id).text(300 - textcount);

    // コメント欄の文字数、画像枚数に応じてコメントボタンを活性/非活性化する
    buttononoff (post_id)
  })

  // タブメニューの切り替え機能
  $(document).on("mouseup", ".main-posts-header-list a", function(){
    $('.active').attr('class', 'non-active');
    $(this).attr('class', 'active');
    // console.log($('.active').attr('href').replace(/\/users\/[0-9]+/g, ''));
  })


  // 関数集 START ------------------------------------------------------------------------------------------------------------------
  // 新規投稿画面でレビュー対象が1文字以上50文字以内かをチェック
  function title_check() {
    var titlelength = $("#newpost-input-title").val().length;
    
    if(titlelength > 50){
      $(".post-input-title").addClass("input-caution");
      $(".post-caution-title").text("レビュー対象は50文字以内で入力してください");
      title_available_flg = "ng";
    } else if(titlelength == 0){
      $(".post-input-title").addClass("input-caution");
      $(".post-caution-title").text("レビュー対象を入力してください");
      title_available_flg = "ng";
    } else {
      $(".post-input-title").removeClass("input-caution");
      $(".post-caution-title").text("");
      title_available_flg = "ok";
    }
  }
  


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
  // 関数集 END --------------------------------------------------------------------------------------------------------------------
})
