$(function (){
  // 名前の入力文字数が30文字以内かどうかをチェック、31文字以上の場合は警告を出す
  $("#signup-input-name").change(function (){
    var namelength = $(this).val().length;
    var name_available_flg = "ng";
    
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
  })

  // メールアドレス
  $("#signup-input-email").change(function (){
    var VALID_EMAIL_REGEX_EMAIL = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
    var email_available_flg = "ng";
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
  })

  // パスワード
  $("#signup-input-password").change(function (){
    var passwordlength = $(this).val().length;
    var VALID_EMAIL_REGEX_PASSWORD = /^[a-zA-Z\d]+$/
    var password_available_flg = "ng";
    if(passwordlength == 0){
      $(this).addClass("input-caution");
      $("#signup-caution-password").text("パスワードを入力してください");
      email_available_flg = "ng";
    } else if(passwordlength < 6 || passwordlength > 30){
      $(this).addClass("input-caution");
      $("#signup-caution-password").text("パスワードは6文字以上30文字以内で入力してください");
      email_available_flg = "ng";
    } else if(!$(this).val().match(VALID_EMAIL_REGEX_PASSWORD)) {
      $(this).addClass("input-caution");
      $("#signup-caution-password").text("半角英数字以外の文字は利用できません");
      email_available_flg = "ng";
    } else {
      $(this).removeClass("input-caution");
      $("#signup-caution-password").text("");
      email_available_flg = "ok";
    }
  })
})