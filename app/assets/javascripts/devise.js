$(function (){
  var name_available_flg = "ng";
  var email_available_flg = "ng";
  var password_available_flg = "ng";
  var password_confirmation_available_flg = "ng";

  // 名前の入力文字数が30文字以内かどうかをチェック、31文字以上の場合は警告を出す
  $("#signup-input-name").change(function (){
    var namelength = $(this).val().length;
    // var name_available_flg = "ng";
    
    if(namelength > 30){
      $(this).addClass("input-caution");
      $("#signup-caution-name").text("名前は30文字以内で入力してください");
      name_available_flg = "ng";
    } else if(namelength == 0){
      $(this).addClass("input-caution");
      $("#signup-caution-name").text("名前を入力してください");
      name_available_flg = "ng";
    } else {
      $(this).removeClass("input-caution");
      $("#signup-caution-name").text("");
      name_available_flg = "ok";
    }

    console.log(name_available_flg + email_available_flg + password_available_flg + password_confirmation_available_flg);
    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  // メールアドレス
  $("#signup-input-email").change(function (){
    var VALID_EMAIL_REGEX_EMAIL = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
    // var email_available_flg = "ng";
    if($(this).val() == ''){
      $(this).addClass("input-caution");
      $("#signup-caution-email").text("メールアドレスを入力してください");
      email_available_flg = "ng";
    } else if(!$(this).val().match(VALID_EMAIL_REGEX_EMAIL)) {
      $(this).addClass("input-caution");
      $("#signup-caution-email").text("不正なフォーマットです");
      email_available_flg = "ng";
    } else {
      $(this).removeClass("input-caution");
      $("#signup-caution-email").text("");
      email_available_flg = "ok";
    }
    console.log(name_available_flg + email_available_flg + password_available_flg + password_confirmation_available_flg);
    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  // パスワード
  $("#signup-input-password").change(function (){
    var passwordlength = $(this).val().length;
    var VALID_EMAIL_REGEX_PASSWORD = /^[a-zA-Z\d]+$/
    // var password_available_flg = "ng";
    if(passwordlength == 0){
      $(this).addClass("input-caution");
      $("#signup-caution-password").text("パスワードを入力してください");
      password_available_flg = "ng";
    } else if(passwordlength < 6 || passwordlength > 30){
      $(this).addClass("input-caution");
      $("#signup-caution-password").text("パスワードは6文字以上30文字以内で入力してください");
      password_available_flg = "ng";
    } else if(!$(this).val().match(VALID_EMAIL_REGEX_PASSWORD)) {
      $(this).addClass("input-caution");
      $("#signup-caution-password").text("半角英数字以外の文字は利用できません");
      password_available_flg = "ng";
    } else {
      $(this).removeClass("input-caution");
      $("#signup-caution-password").text("");
      password_available_flg = "ok";
    }

    if($("#signup-input-password_confirmation").val().length != 0){
    password_confirmation_check();
    }
    console.log(name_available_flg + email_available_flg + password_available_flg + password_confirmation_available_flg);
    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  // （確認用）パスワード
  $("#signup-input-password_confirmation").change(function (){
    password_confirmation_check();
    console.log(name_available_flg + email_available_flg + password_available_flg + password_confirmation_available_flg);
    buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg);
  })

  function password_confirmation_check() {
    // var password_confirmation_available_flg = "ng";
    if($("#signup-input-password_confirmation").val().length == 0){
      $("#signup-input-password_confirmation").addClass("input-caution");
      $("#signup-caution-password_confirmation").text("確認用にパスワードをもう一度入力してください");
      password_confirmation_available_flg = "ng";
    } else if($("#signup-input-password_confirmation").val() != $("#signup-input-password").val()){
      $("#signup-input-password_confirmation").addClass("input-caution");
      $("#signup-caution-password_confirmation").text("パスワードと一致していません");
      password_confirmation_available_flg = "ng";
    } else {
      $("#signup-input-password_confirmation").removeClass("input-caution");
      $("#signup-caution-password_confirmation").text("");
      password_confirmation_available_flg = "ok";
    }
  }

  // 全ての入力値が問題無ければ、登録ボタンを活性化。そうでなければ非活性化する
  function buttonToggle(name_available_flg, email_available_flg, password_available_flg, password_confirmation_available_flg) {
    if(name_available_flg == "ok" && email_available_flg == "ok" && password_available_flg == "ok" && password_confirmation_available_flg == "ok") {
      $("#signup-button-submit").removeAttr("disabled");
    } else {
      $("#signup-button-submit").attr("disabled", true);
    }
  }
})