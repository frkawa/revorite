$(function (){
  // 各項目のバリデーションチェック用フラグ項目
  var rev_flg = $("#newpost-rev_flg").prop("checked");
  var title_available_flg = "ng";
  var price_available_flg = "ng";
  var text_available_flg = "ng";
  var filecount = 0;

  // 投稿一覧画面（タイムライン、最新の投稿、人気の投稿） START ----------------------------------------------------------------------------
  // 無限スクロール。最初はコントローラで指定した件数のみ投稿を読み込み、スクロールする度に追加で指定件数の投稿を取得してくる
  $('.jscroll').jscroll({
    contentSelector: '.main-posts-contents', 
    nextSelector: 'a.next-page'
  });

  // 最初に読み込んだ投稿の画像に対し、Luminous（画像クリックでモーダルウィンドウで拡大表示できるjQueryプラグイン）を適用する
  var initial_target = ".jscroll-inner";
  luminous(initial_target);

  // 最初に読み込んだ投稿のレビューに対し、評価の星を表示する
  $(initial_target + " .post-review-star").each(function (i, elm){
    var id = $(elm).attr('id').replace(/star-/g, '');
    var rate = $(elm).attr('rate');
    display_rate(id, rate);
  })

  // プロフィール画像にもLuminousを適用する
  var luminousTrigger = document.querySelector('.luminous-profile');
  if( luminousTrigger !== null ) {
    new Luminous(luminousTrigger);
  }

  // スクロールで追加の投稿を読み込んだ際、MutationObserverでそれを検知し、①追加で読み込んだ投稿の画像にもLuminousを適用する、②レビューがある投稿の評価の星を表示する
  var inf_scroll_times = 0;
  var observer = new MutationObserver(function() {
    if($(".jscroll-added:last-of-type .main-posts-contents").length){ // jscrollの仕様上、これが無いと無駄な検知が増えるため入れている
      if(inf_scroll_times != $(".jscroll-added").length){ // コメントを入力したりお気に入りに入れるだけで検知しないように入れている
        // 無限ループを防ぐ為にDOM変化の監視を一時停止する
        observer.disconnect();

        next_target = ".jscroll-added:last-of-type";
        // Luminousを適用
        luminous(next_target);

        // 評価の星を表示
        $(next_target + " .post-review-star").each(function (i, elm){
          var id = $(elm).attr('id').replace(/star-/g, '');
          var rate = $(elm).attr('rate');
          display_rate(id, rate);
        })

        // 無限スクロールした回数を更新
        inf_scroll_times = $(".jscroll-added").length;

        // DOM変化の監視を再開する
        observer.observe(elem, config);
      }
    }
  });

  // MutationObserverの監視対象、オプション
  const elem = document.querySelector(".jscroll-inner");
  const config = { 
    attributes: false, 
    childList: true, 
    characterData: false,
    subtree: true
  };

  // MutationObserverの実行
  if(elem){
    observer.observe(elem, config);
  }
  // 投稿一覧画面（タイムライン、最新の投稿、人気の投稿） END ------------------------------------------------------------------------------


  // コメント投稿関連 START ----------------------------------------------------------------------------------------------------------
  // 各投稿のコメントボタンを押すとコメント欄を開く、または折り畳む
  var clickEventType = ((window.ontouchstart !== null)?'click':'touchstart');
  $(document).on(clickEventType, ".post-action__comment", function(){
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
      var cancelstr = '一度に投稿できる画像は4枚までです';
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
  // コメント投稿関連 END ------------------------------------------------------------------------------------------------------------


  // 新規投稿画面 START -------------------------------------------------------------------------------------------------------------
  // 新規投稿画面を読み込んだ時、本文の残り記入可能文字数を記述する
  if($("#newpost-input-text").length){
    $("#newpost-input-text__textcount").text(500 - $("#newpost-input-text").val().length);
  }

  // 新規投稿画面を読み込んだ時、「レビューする」にチェックが付いていたらレビューに必要な入力項目を表示しておく
  if(rev_flg) {
    $(".newpost-items__review").css("display", "block");
  }

  // 「レビューをする」をチェックするとレビューに必要な入力項目を表示する、チェックを外すと隠す
  $("#newpost-rev_flg").change(function (){
    $(".newpost-items__review").slideToggle('fast');
    rev_flg = $("#newpost-rev_flg").prop("checked");
    if($("#newpost-input-text").val().length != 0){
      text_check();
    }
    postButtonToggle(rev_flg, title_available_flg, price_available_flg, text_available_flg);
  })

  // レビュー対象が入力・変更された時、バリデーションチェックを行う
  $("#newpost-input-title").change(function (){
    title_check();
    if($("#newpost-input-text").val().length != 0){
      text_check();
    }
    postButtonToggle(rev_flg, title_available_flg, price_available_flg, text_available_flg);
  })

  // 価格が入力・変更された時、バリデーションチェックを行う
  $("#newpost-input-price").change(function (){
    price_check();
    if($("#newpost-input-text").val().length != 0){
      text_check();
    }
    postButtonToggle(rev_flg, title_available_flg, price_available_flg, text_available_flg);
  })

  // 本文を入力・変更する毎に残り記入可能文字数を更新し、併せてバリデーションチェックを行う
  $("#newpost-input-text").keyup(function (){
    var textcount = $("#newpost-input-text").val().length;
    $("#newpost-input-text__textcount").text(500 - textcount);
    
    text_check();
    postButtonToggle(rev_flg, title_available_flg, price_available_flg, text_available_flg);
  })

  // 投稿する画像を選択した時、バリデーションチェックを行い、問題無ければプレビュー画像を表示する
  $("#newpost-file_field").change(function() {
    $(".newpost-items__previewimages").html("");
    filecount = this.files.length;

    // バリデーション：一度に投稿できる画像は4枚まで、4枚以上を選択している場合はアラートを出して中断する
    if(this.files.length > 4){
      alert("一度に投稿できる画像は4枚までです");
      filecount = 0;
      return;
    }

    for(i = 0; i < filecount; i++){
      // バリデーション：ファイル形式がjpeg, jpg, png以外の場合はアラートを出して中断する
      if(this.files[i].type != "image/jpeg" && this.files[i].type != "image/png"){
        alert("画像はjpegまたはpng形式でアップロードしてください");
        filecount = 0;
        return;
      }
      // バリデーション：3MBを超える画像を選択した場合はアラートを出して中断する
      if(this.files[i].size > 3145728){
        alert("画像は1ファイルにつき3MB以内にしてください");
        filecount = 0;
        return;
      }
    }

    // プレビューを画面に表示する
    for(i = 0; i < filecount; i++){
      var reader = new FileReader();
      reader.name = this.files[i].name;

      $(reader).on("load", function (){
        $("<img>").appendTo(".newpost-items__previewimages")
        .prop({"src": this.result, "title": this.name});
      });

      if (this.files[i]) {
        reader.readAsDataURL(this.files[i]);
      }
    }

    // 画像を投稿する場合は本文入力は任意のため、text_checkを再度行う
    text_check();

    postButtonToggle(rev_flg, title_available_flg, price_available_flg, text_available_flg);
  });
  
  // 新規投稿画面 END ---------------------------------------------------------------------------------------------------------------



  // 関数集 START ------------------------------------------------------------------------------------------------------------------
  // レビューの評価の星を表示する
  function display_rate(post_id, rate) {
    $("#star-" + post_id).raty({
      size: 36,
      starOff: $("#star-none").attr('image_path'),
      starOn: $("#star-full").attr('image_path'),
      starHalf: $("#star-half").attr('image_path'),
      score: rate,
      half: true,
      readOnly: true
    });
  }

  // Luminousを使用し、投稿画像（コメントの画像も含む）をクリックした際にモーダルウィンドウで拡大表示する
  function luminous(target) {
    var post_previous_class = "none";
    var post_hash_images = {};
  
    $(target + " [class^='luminous-post-']").each(function (i, elm){
      if($(elm).attr("class") != post_previous_class){
        post_hash_images[$(elm).attr("class")] = "single";
      } else {
        post_hash_images[$(elm).attr("class")] = "multiple";
      }
      post_previous_class = $(elm).attr("class");
    })
  
    Object.keys(post_hash_images).forEach(function(key){
      if(post_hash_images[key] == "multiple") {
        var luminousTrigger = document.querySelectorAll('.' + key);
        new LuminousGallery(luminousTrigger);
      } else if(post_hash_images[key] == "single"){
        var luminousTrigger = document.querySelector('.' + key);
        new Luminous(luminousTrigger);
      }
    });
  
    // コメントの画像も同様に拡大表示できるようにする
    var comment_previous_class = "none";
    var comment_hash_images = {};
  
    $(target + " [class^='luminous-comment-']").each(function (i, elm){
      if($(elm).attr("class") != comment_previous_class){
        comment_hash_images[$(elm).attr("class")] = "single";
      } else {
        comment_hash_images[$(elm).attr("class")] = "multiple";
      }
      comment_previous_class = $(elm).attr("class");
    })
  
    Object.keys(comment_hash_images).forEach(function(key){
      if(comment_hash_images[key] == "multiple") {
        var luminousTrigger = document.querySelectorAll('.' + key);
        new LuminousGallery(luminousTrigger);
      } else if(comment_hash_images[key] == "single"){
        var luminousTrigger = document.querySelector('.' + key);
        new Luminous(luminousTrigger);
      }
    });
  }

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
  
  // 新規投稿画面で価格が0〜99,999,999の範囲内かをチェック
  function price_check() {
    var price = Number($("#newpost-input-price").val());
    
    if(Number.isInteger(price)){
      if(price < 0 || price >= 100000000){
        $(".post-input-price").addClass("input-caution");
        $(".post-caution-price").text("価格は半角数字で0〜99,999,999の整数値で入力してください");
        price_available_flg = "ng";
      } else {
        $(".post-input-price").removeClass("input-caution");
        $(".post-caution-price").text("");
        price_available_flg = "ok";
      }
    } else {
      $(".post-input-price").addClass("input-caution");
      $(".post-caution-price").text("価格は半角数字で0〜99,999,999の整数値で入力してください");
      price_available_flg = "ng";
    }
  }

  // 新規投稿画面で本文が1文字以上500文字以内かをチェック
  function text_check() {
    var textcount = $(".post-input-text").val().length

    if(textcount > 500){
      $(".post-input-text").addClass("input-caution");
      $(".post-caution-text").text("本文は500文字以内で入力してください");
      text_available_flg = "ng";
    } else if(textcount == 0 && filecount == 0) {
      text_available_flg = "ng";
    } else {
      $(".post-input-text").removeClass("input-caution");
      $(".post-caution-text").text("");
      text_available_flg = "ok";
    }
  }

  // 各項目チェックで設定したフラグに応じて新規投稿画面のボタンの活性化/非活性化を行う
  function postButtonToggle(rev_flg, title_available_flg, price_available_flg, text_available_flg){
    if(rev_flg){
      if(title_available_flg == "ok" && price_available_flg == "ok" && text_available_flg == "ok"){
        $(".post-button-submit").removeAttr("disabled");
      } else {
        $(".post-button-submit").attr("disabled", true);
      }
    } else {
      if(text_available_flg == "ok"){
        $(".post-button-submit").removeAttr("disabled");
      } else {
        $(".post-button-submit").attr("disabled", true);
      }
    }
  }

  // コメントの入力文字数及び画像枚数より、コメントボタンを活性化/非活性化する
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

  // コメント投稿時に画像を選択した際、バリデーションチェックでNGの場合はアラートを出して画像選択を解除する
  function cancelupload(post_id, alertstr) {
    alert(alertstr);
    $("#" + post_id + "-comment-images").val('');
    $("#previewimages-" + post_id).html('');
    buttononoff(post_id);
  }
  // 関数集 END --------------------------------------------------------------------------------------------------------------------
})
