$(function (){
  // 名前の入力文字数が30文字以内かどうかをチェック、31文字以上の場合は警告を出す
  $("#signup-input-name").change(function (){
    var namelength = $(this).val().length;
    var name_available_flg = "ng";
    
    if(namelength > 30){
      $(this).addClass("input-caution");
      $("#signup-caution-name").text("名前は30文字以内で入力してください");
      name_available_flg = "ng";
      console.log(namelength);
      console.log(name_available_flg);
    } else if(namelength == 0){
      $(this).removeClass("input-caution");
      $("#signup-caution-name").text("");
      name_available_flg = "ng";
      console.log(namelength);
      console.log(name_available_flg);
    } else {
      $(this).removeClass("input-caution");
      $("#signup-caution-name").text("");
      name_available_flg = "ok";
      console.log(namelength);
      console.log(name_available_flg);
    }
  })


})