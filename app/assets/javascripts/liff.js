function initializeApp(data) {
  // userのvalidationを行う。悪意のあるユーザーを排除
  liff.getProfile().then(function (profile) {
    $.ajax({
      type: 'POST',
      url: '/api/validate_chat_unit',
      data: {
        entity: {
          user: {
            line_id: profile.userId,
            name: profile.displayName,
            profile_picture_url: profile.pictureUrl
          },
          room: {
            line_id: data.context.roomId
          },
          group: {
            line_id: data.context.groupId
          }
        }
      },
      success: function (res, status) {
        var profile_picture_url = res.profile_picture_url
        if (profile_picture_url != null) {
          $("#dropbtn-nouser").css("display", "none")
          $("#dropbtn-img").css("display", "block")
          $("#dropbtn-img").attr("src",profile_picture_url);
        } else {
          $("#dropbtn-nouser").empty();
          $("#dropbtn-nouser").append('<i class="fas fa-portrait fa-2x"></i>')
        }
        $(".user-menu-content").empty();
        $( ".user-menu-content" ).append( "<a href='/restaurant_data_sets'>マイリスト</a>" );
        $( ".user-menu-content").append("<a href='#'>Uzu Meshiとは?</a>")

        $(".loading").remove()
        $(".main").removeClass("is-hide");
      },
      error: function (res) {
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus: " + res.status);
        liff.closeWindow();
      },
      complete: function(data) {}
    });
  }).catch(function (error) {
    window.alert("Error getting profile: " + error);
    liff.closeWindow();
  });
}