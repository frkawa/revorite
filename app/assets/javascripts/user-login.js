$(function (){
  // メールアドレスが入力されたらログインボタン活性化/非活性化関数をコールする
  $("#login-input-email").change(function (){
    buttonToggle();
  })

  // パスワードが入力されたらログインボタン活性化/非活性化関数をコールする
  $("#login-input-password").change(function (){
    buttonToggle();
  })

  // メールアドレスとパスワードが入力されていれば、ログインボタンを活性化。そうでなければ非活性化する
  function buttonToggle() {
    if($("#login-input-email").val().length > 0 && $("#login-input-password").val().length > 0) {
      $("#login-button-submit").removeAttr("disabled");
    } else {
      $("#login-button-submit").attr("disabled", true);
    }
  }
})