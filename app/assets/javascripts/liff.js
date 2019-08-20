window.onload = function (e) {
  $(".section").removeClass("is-hide"); // for debugging in browser
  liff.init(function (data) {
    initializeApp(data);
  });
};

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  $("#location-choices").toggle(false);
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
        var returnedSearchHistory = res.search_history;
        if (returnedSearchHistory != "null") {
          $(".form-group").addClass("input-not-empty");
          var formElements = ["location", "meal-type", "lower-budget", "upper-budget", "meal-genre"]
          formElements.map(function( element ) {
            $("#"+element)[0].value = res.search_history[element.replace("-", "_")]
          });
        }

        $(".section").removeClass("is-hide");
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
var decidedLocation, inputMealType, inputLowerBudget, inputUpperBudget;

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
function onChangeMealType() { 
  inputMealType = document.getElementById("meal-type").value }
function onChangeLowerBudget() {
  inputLowerBudget = document.getElementById("lower-budget").value;
  validateBudget();
}
function onChangeUpperBudget() {
  inputUpperBudget = document.getElementById("upper-budget").value;
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
  console.log("reached");
  debugger;
  $.ajax({
    type: 'POST',
    url: '/api/line/callback_liff',
    data: {
      line_liff: {
        location: decidedLocation.trim(),
        meal_type: inputMealType,
        genre: inputMealGenre,
        budget: {
          lower: inputLowerBudget,
          upper: inputUpperBudget
        }
      }
    },
    success: function (res, status) {
      window.alert('メッセージが送られました！ご確認下さい。');
      liff.closeWindow();
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
}

function validateBudget() {
  var lowerBudgetValue = parseInt(inputLowerBudget); var upperBudgetValue = parseInt(inputUpperBudget)

  if (inputLowerBudget == 0 || upperBudgetValue == 0) {
    lowerBudget.setCustomValidity("");
    upperBudget.setCustomValidity("");
    return;
  };

  if (lowerBudgetValue >= upperBudgetValue) {
    lowerBudget.setCustomValidity("予算を正しく入力してください");
    upperBudget.setCustomValidity("予算を正しく入力してください");
    return;
  };

  lowerBudget.setCustomValidity("");
  upperBudget.setCustomValidity("");
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
  if (genres.style.display === "block") {
    genres.style.display = "none";
    budgetArrow.style.top = "45%"
  } else {
    genres.style.display = "block";
    budgetArrow.style.top = "38.5%"
  }
}

var genreSelectCount = 0;
var genreButtons = $(".genre-button");
var userSelection = [];

function onClickMealGenreElement(e) {
  e.preventDefault();

  var genreSelectionText = $("#genre-selection-text");
  var genreButton = $("#"+e.currentTarget.id);

  if (e.currentTarget.id == "指定なし") {
    if (genreButton.hasClass("selected")) {
      genreButtons.removeClass("selected");
      genreSelectCount = 0;
      userSelection.splice(userSelection.indexOf(e.target.id), 1);
    } else {
      genreButtons.addClass("selected");
      genreSelectCount = genreButtons.length - 1;
      userSelection.push(e.target.id);
    }
  } else {
    if (genreButton.hasClass("selected")) {
      genreButton.removeClass("selected");
      genreSelectCount -= 1;
      userSelection.splice(userSelection.indexOf(e.target.id), 1);
    } else {
      genreButton.addClass("selected");
      $("#指定なし").removeClass("selected");
      genreSelectCount += 1;
      userSelection.push(e.target.id);
    }
  }

  if (genreSelectCount == 19) {
    $("#指定なし").addClass("selected");
  }

  console.log(userSelection);
  $(".meal-genre-form-group").addClass("input-not-empty");
  genreSelectionText.text(genreSelectCount + " 個選択");
}

