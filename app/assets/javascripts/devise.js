$(function (){
  // 各項目のバリデーションチェック用フラグ項目
  var name_available_flg = "ng";
  var email_available_flg = "ng";
  var password_available_flg = "ng";
  var password_confirmation_available_flg = "ng";

  // ユーザ登録画面 START -----------------------------------------------------------------------------------------------------------
  // 名前欄が入力された・変更された場合にチェック処理をコールする。
  // フロントのバリデーションチェックでOK、バックの同チェックでNGとなった場合は全項目のチェックフラグが初期化（ng）されるため、
  // 値が入っている場合は他の項目も併せてチェックする
  $("#signup-input-name").change(function (){
    name_check();

    if($("#signup-input-email").val().length != 0){
      email_check();
    }
    if($("#signup-input-password").val().length != 0){
      password_check();
    }
    if($("#signup-input-password_confirmation").val().length != 0){
      password_confirmation_check();
    }

    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  // メールアドレス欄が入力された・変更された場合にチェック処理をコールする。
  // 名前欄のチェックと同様に、値が入っている場合は他の項目も併せてチェックする。
  $("#signup-input-email").change(function (){
    email_check();

    if($("#signup-input-name").val().length != 0){
      name_check();
    }
    if($("#signup-input-password").val().length != 0){
      password_check();
    }
    if($("#signup-input-password_confirmation").val().length != 0){
      password_confirmation_check();
    }

    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  // パスワード欄が入力された・変更された場合にチェック処理をコールする。
  // 名前欄のチェックと同様に、値が入っている場合は他の項目も併せてチェックする。
  $("#signup-input-password").change(function (){
    password_check();

    if($("#signup-input-name").val().length != 0){
      name_check();
    }
    if($("#signup-input-email").val().length != 0){
      email_check();
    }
    if($("#signup-input-password_confirmation").val().length != 0){
      password_confirmation_check();
    }

    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  // パスワード（確認用）欄が入力された・変更された場合にチェック処理をコールする。
  // 名前欄のチェックと同様に、値が入っている場合は他の項目も併せてチェックする。
  $("#signup-input-password_confirmation").change(function (){
    password_confirmation_check();

    if($("#signup-input-name").val().length != 0){
      name_check();
    }
    if($("#signup-input-email").val().length != 0){
      email_check();
    }
    if($("#signup-input-password").val().length != 0){
      password_check();
    }

    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })
  // ユーザ登録画面 END -------------------------------------------------------------------------------------------------------------


  // ログイン画面 START -------------------------------------------------------------------------------------------------------------
  // メールアドレスとパスワードが入力されたらログインボタンを活性化する
  // 新規登録ではないのでメールアドレス・パスワードどちらもバリデーションチェックは不要。両方が入力されてさえいればOK
  $("#login-input-email, #login-input-password").change(function (){
    if($("#login-input-email").val().length != 0 && $("#login-input-password").val().length != 0){
      buttonToggle("ok", "ok", "ok", "ok");
    }
  })
  // ログイン画面 END ---------------------------------------------------------------------------------------------------------------


  // プロフィール編集画面 START ------------------------------------------------------------------------------------------------------
  // プロフィール編集画面 END --------------------------------------------------------------------------------------------------------


  // 関数集 START ------------------------------------------------------------------------------------------------------------------
  // 名前の入力文字数が1文字以上30文字以内かをチェック
  function name_check() {
    var namelength = $(".user-input-name").val().length;
    
    if(namelength > 30){
      $(".user-input-name").addClass("input-caution");
      $(".user-caution-name").text("名前は30文字以内で入力してください");
      name_available_flg = "ng";
    } else if(namelength == 0){
      $(".user-input-name").addClass("input-caution");
      $(".user-caution-name").text("名前を入力してください");
      name_available_flg = "ng";
    } else {
      $(".user-input-name").removeClass("input-caution");
      $(".user-caution-name").text("");
      name_available_flg = "ok";
    }
  }

  // メールアドレスが1文字以上255文字以内か、メールアドレスとしてのフォーマットを満たしているかをチェック
  function email_check() {
    var emaillength = $(".user-input-email").val().length;
    var VALID_EMAIL_REGEX_EMAIL = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/

    if(emaillength == 0){
      $(".user-input-email").addClass("input-caution");
      $(".user-caution-email").text("メールアドレスを入力してください");
      email_available_flg = "ng";
    } else if(emaillength > 255) {
      $(".user-input-email").addClass("input-caution");
      $(".user-caution-email").text("メールアドレスは255文字以内で入力してください");
      email_available_flg = "ng";  
    } else if(!$(".user-input-email").val().match(VALID_EMAIL_REGEX_EMAIL)) {
      $(".user-input-email").addClass("input-caution");
      $(".user-caution-email").text("不正なフォーマットです");
      email_available_flg = "ng";
    } else {
      $(".user-input-email").removeClass("input-caution");
      $(".user-caution-email").text("");
      email_available_flg = "ok";
    }
  }

  // パスワードが6文字以上30文字以内か、また半角英数字以外の文字が使われていないかをチェック
  function password_check() {
    var passwordlength = $(".user-input-password").val().length;
    var VALID_EMAIL_REGEX_PASSWORD = /^[a-zA-Z\d]+$/

    if(passwordlength == 0){
      $(".user-input-password").addClass("input-caution");
      $(".user-caution-password").text("パスワードを入力してください");
      password_available_flg = "ng";
    } else if(passwordlength < 6 || passwordlength > 30){
      $(".user-input-password").addClass("input-caution");
      $(".user-caution-password").text("パスワードは6文字以上30文字以内で入力してください");
      password_available_flg = "ng";
    } else if(!$(".user-input-password").val().match(VALID_EMAIL_REGEX_PASSWORD)) {
      $(".user-input-password").addClass("input-caution");
      $(".user-caution-password").text("半角英数字以外の文字は利用できません");
      password_available_flg = "ng";
    } else {
      $(".user-input-password").removeClass("input-caution");
      $(".user-caution-password").text("");
      password_available_flg = "ok";
    }
  }

  // 確認用パスワードがパスワードと一致しているかをチェック
  function password_confirmation_check() {
    if($(".user-input-password_confirmation").val().length == 0){
      $(".user-input-password_confirmation").addClass("input-caution");
      $(".user-caution-password_confirmation").text("確認用にパスワードをもう一度入力してください");
      password_confirmation_available_flg = "ng";
    } else if($(".user-input-password_confirmation").val() != $(".user-input-password").val()){
      $(".user-input-password_confirmation").addClass("input-caution");
      $(".user-caution-password_confirmation").text("パスワードと一致していません");
      password_confirmation_available_flg = "ng";
    } else {
      $(".user-input-password_confirmation").removeClass("input-caution");
      $(".user-caution-password_confirmation").text("");
      password_confirmation_available_flg = "ok";
    }
  }

  // 各項目チェックで設定したフラグに応じてボタンの活性化/非活性化を行う
  function buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg) {
    if(name_available_flg == "ok" && email_available_flg == "ok" && password_available_flg == "ok" && password_confirmation_available_flg == "ok") {
      $(".user-button-submit").removeAttr("disabled");
    } else {
      $(".user-button-submit").attr("disabled", true);
    }
  }
  // 関数集 END --------------------------------------------------------------------------------------------------------------------
})