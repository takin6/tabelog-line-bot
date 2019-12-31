var isMobile = false; //initiate as false

window.onload = function (e) {
  // device detection
  if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) 
      || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) { 
      isMobile = true;
  }

  if (isMobile) {
    liff.init(function (data) {
      initializeApp(data);
    });
  } else {
    $(".loading").remove()
    $(".main").removeClass("is-hide");
  }
};

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  $("#location-choices").toggle(false);
}

/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function onClickUserMenu() {
  $(".user-menu-content").toggle();
}

document.addEventListener('keydown', function (event) {
  if (event.which == 13) {
    event.preventDefault();
  }
}, false);

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
        if (profile_picture_url != "null") {
          $("#dropbtn-nouser").css("display", "none")
          $("#dropbtn-img").css("display", "block")
          $("#dropbtn-img").attr("src",profile_picture_url);

          $(".user-menu-content").empty();
          $( ".user-menu-content" ).append( "<a href='/restaurant_data_sets'>マイリスト</a>" );
          $( ".user-menu-content" ).append( "<a rel='nofollow' data-method='delete' href='/user/auth/logout'>サインアウト</a>" );
          $( ".user-menu-content").append("<a href='#'>Uzu Meshiとは?</a>")
        }

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

var lowerBudget = document.getElementById('lower-budget'); var upperBudget = document.getElementById('upper-budget');
var inputLocation = document.getElementById('location'); 
var inputMealGenre = document.getElementById('meal-genre'); 
var inputMealType = document.getElementById("meal-type");
var inputLowerBudget = document.getElementById("lower-budget");
var inputUpperBudget = document.getElementById("upper-budget");
var decidedLocation;

function onInputLocation(e) {
  decidedLocation = "";
  inputLocation.setCustomValidity("場所を正しく入力してください");
  getSuggetWords();
  if (e.currentTarget.value.length > 1 && $(".location-choice-list").length > 0 && decidedLocation == "") {
    $("#location-choices").toggle(true)
  } else {
    $("#location-choices").toggle(false)
  }
}

function onClickLocationChoice(e) {
  // idにする
  var userChoice = e.currentTarget.innerText
  decidedLocation = userChoice;
  inputLocation.value = userChoice;
  inputLocation.setCustomValidity("");
}

function onChangeBudget() {
  validateBudget();
}

function onInputMealGenre() {
  var genres = document.getElementById("genres");
  var budgetArrow = document.getElementById("budget-arrow");
  genres.style.display = "none";
  budgetArrow.style.top = "45%";
}

function onClickMealGenre() {
  $(".meal-genre-form-group").addClass("input-not-empty");
}

function onChangeMealGenre(event) {
  $(".meal-genre-form-group").addClass("input-not-empty");
}

function onResetSearchRestaurant() {
  $(".form-group").removeClass("input-not-empty")
  $(".search-restaurant-form")[0].reset()
}

function onSubmitSearchRestaurant(event) {
  event.preventDefault(); 

  $.ajax({
    type: 'POST',
    url: '/api/custom_restaurants',
    data: {
      line_liff: {
        location: decidedLocation.trim(),
        meal_type: inputMealType.value,
        genre: {
          custom_input: ["指定なし", ""].includes(inputMealGenre.value) ? undefined : inputMealGenre.value,
          master_genres: transformMasterGenresToParam()
        },
        budget: {
          lower: inputLowerBudget.value,
          upper: inputUpperBudget.value
        }
      }
    },
    success: function (res, status) {
      // sessionStorage.setItem("mongo_custom_restaurants", JSON.stringify(res.mongo_custom_restaurants))
      window.location.href = `/restaurant_data_sets/new?cache_id=${res.mongo_custom_restaurants.cache_id}`;
      // window.alert('メッセージが送られました！ご確認下さい。');
      // liff.closeWindow();
    },
    error: function (res, status) {
      if (status == 505) {
        window.alert('invalid session: ' + res.status);
        liff.closeWindow();
      } else {
        // alert(JSON.parse(res.responseText));
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
      }
    },
    complete: function(data) {}
  });

  // $.ajax({
  //   type: 'POST',
  //   url: '/api/line/callback_liff',
  //   data: {
  //     line_liff: {
  //       location: decidedLocation.trim(),
  //       meal_type: inputMealType.value,
  //       genre: {
  //         custom_input: ["指定なし", ""].includes(inputMealGenre.value) ? undefined : inputMealGenre.value,
  //         master_genres: transformMasterGenresToParam()
  //       },
  //       budget: {
  //         lower: inputLowerBudget.value,
  //         upper: inputUpperBudget.value
  //       }
  //     }
  //   },
  //   success: function (res, status) {
  //     window.alert('メッセージが送られました！ご確認下さい。');
  //     liff.closeWindow();
  //   },
  //   error: function (res, status) {
  //     if (status == 505) {
  //       window.alert('invalid session: ' + res.status);
  //       liff.closeWindow();
  //     } else {
  //       // alert(JSON.parse(res.responseText));
  //       window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
  //     }
  //   },
  //   complete: function(data) {}
  // });
}

function transformMasterGenresToParam() {
  result = [];

  selectedGenreButtons = $(".genre-button.selected");
  if (selectedGenreButtons.length > 22) {
    result.push("指定なし")
  } else {
    for (var i=0; i<selectedGenreButtons.length; i++) {
      result.push(selectedGenreButtons[i].textContent);
    }
  }

  if (result.length == 0 && inputMealGenre.value == "") {
    result.push("指定なし");
  }

  return result;
}

function validateBudget() {
  var inputLowerBudgetValue = inputLowerBudget.value;
  var inputUpperBudgetValue = inputUpperBudget.value;
  var lowerBudgetValue = parseInt(inputLowerBudgetValue); var upperBudgetValue = parseInt(inputUpperBudgetValue)

  if (lowerBudgetValue == 0 || upperBudgetValue == 0) {
    inputLowerBudget.setCustomValidity("");
    inputUpperBudget.setCustomValidity("");
    return;
  };

  if (lowerBudgetValue >= upperBudgetValue) {
    inputLowerBudget.setCustomValidity("予算を正しく入力してください");
    inputUpperBudget.setCustomValidity("予算を正しく入力してください");
    return;
  };

  inputLowerBudget.setCustomValidity("");
  inputUpperBudget.setCustomValidity("");
}

var timeout = null
function getSuggetWords() {
  clearTimeout(timeout);
  // 2文字以上入力された場合にサジェストワードを取得
  if (inputLocation.value.length > 1) {
　　// setTimeoutを使ってapiが呼ばれるまでに時間を置く
    timeout = setTimeout(function () {
      $.ajax({
        type: 'GET',
        url: '/api/stations/suggests?query='+inputLocation.value,
        success: function (res, status) {
          var result = res.stations;
          updateSuggestWords(result);
        },
        error: function (res) {
          window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus: " + res.status);
          liff.closeWindow();
        },
        complete: function(data) {}
      });
    }, 300);
  }
}

function updateSuggestWords(result) {
  if (result.length > 0) {
    const dropdownMenu = document.querySelector("#location-choices");

    let stationList = "";
    result.forEach(station_json => {
      stationList += `<li class="location-choice-element" id=${station_json["id"]} onclick="onClickLocationChoice(event)"><a href="#">${station_json["name"]}</a></li>`
    });

    const html = `<ul class="location-choice-list">${stationList}</ul>`;

    dropdownMenu.innerHTML = html;
    displaySuggestList();
  }
}

function displaySuggestList() {
  /* When the user clicks on the button, 
  toggle between hiding and showing the dropdown content */
  $("#location-choices").toggle(true)
}

function onClickGenreBar() {
  var genres = document.getElementById("genres");
  var budgetArrow = document.getElementById("budget-arrow");
  genres.style.display === "block" ? closeGenreBar() : openGenreBar();
}

var genres = document.getElementById("genres");
var budgetArrow = document.getElementById("budget-arrow");
function openGenreBar() {
  genres.style.display = "block";
  if (window.matchMedia('(min-width:640px)').matches) {
    budgetArrow.style.top = "35%"
  } else {
    budgetArrow.style.top = "26%";
  }
}

function closeGenreBar() {
  genres.style.display = "none";
  budgetArrow.style.top = "45%"
}

var genreSelectCount = 0;
var genreButtons = $(".genre-button");

function onClickMealGenreElement(e) {
  e.preventDefault();

  var genreSelectionText = $("#genre-selection-text");
  var genreButton = $("#"+e.currentTarget.id);

  if (e.currentTarget.id == "指定なし") {
    if (genreButton.hasClass("selected")) {
      genreButtons.removeClass("selected");
      enableInputMealGenre();
      genreSelectCount = 0;
    } else {
      genreButtons.addClass("selected");
      genreSelectCount = genreButtons.length - 1;
      disableInputMealGenre();
    }
  } else {
    if (genreButton.hasClass("selected")) {
      genreButton.removeClass("selected");
      genreSelectCount -= 1;
      if ($("#指定なし").hasClass("selected")) {
        $("#指定なし").removeClass("selected");
        enableInputMealGenre();
      }
    } else {
      genreButton.addClass("selected");
      genreSelectCount += 1;
      if (genreSelectCount == 22) {
        $("#指定なし").addClass("selected");
        disableInputMealGenre();
      }
    }
  }

  $(".meal-genre-form-group").addClass("input-not-empty");
  genreSelectionText.text(genreSelectCount + " 個選択");
}

function disableInputMealGenre() {
  inputMealGenre.value = "指定なし";
  inputMealGenre.disabled = true
}

function enableInputMealGenre() {
  inputMealGenre.value = "";
  inputMealGenre.disabled = false
}



// function fillCacheToForm(returnedSearchHistory) {
//   $(".form-group").addClass("input-not-empty");

//   var formElements = ["location", "meal-type", "lower-budget", "upper-budget"]
//   formElements.map(function( element ) {
//     $("#"+element)[0].value = returnedSearchHistory[element.replace("-", "_")]
//   });

//   decidedLocation = returnedSearchHistory["location"]

//   $("#meal-genre")[0].value = returnedSearchHistory["custom_meal_genre"];

//   var returned_master_genres = returnedSearchHistory["master_genres"]

//   if (returned_master_genres == null) {
//     if (returnedSearchHistory["custom_meal_genre"] == null) {
//       genreButtons.addClass("selected");
//       genreSelectCount = 22;
//       disableInputMealGenre();
//       openGenreBar();
//     }
//   } else {
//     returned_master_genres.forEach(function(master_genre) {
//       $("#"+master_genre["id"]).addClass("selected");
//       genreSelectCount += 1;
//     });
//     openGenreBar();
//   }

//   $(".meal-genre-form-group").addClass("input-not-empty");
//   $("#genre-selection-text").text(genreSelectCount + " 個選択");
// }


