window.onload = function (e) {
  liff.init(function (data) {
    initializeApp(data);
  });
  // initializeApp({});
};

function initializeApp(data) {
  // userのvalidationを行う。悪意のあるユーザーを排除
  var $section = $(".section");

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
        $section.removeClass("is-hide");
      },
      error: function (res) {
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus: " + res.status);
        liff.closeWindow();
      },
      complete: function(data) {
      }
    });
  }).catch(function (error) {
    window.alert("Error getting profile: " + error);
    liff.closeWindow();
  });
}

var lowerBudget = document.getElementById('lower-budget'); var upperBudget = document.getElementById('upper-budget');
var inputLocation, inputMealType, inputLowerBudget, inputUpperBudget, inputMealKind;
function onChangeLocation() { inputLocation = document.getElementById("location").value; }
function onChangeMealType() { inputMealType = document.getElementById("meal-type").value }
function onChangeLowerBudget() { 
  inputLowerBudget = document.getElementById("lower-budget").value;
  validateBudget();
}
function onChangeUpperBudget() {
  inputUpperBudget = document.getElementById("upper-budget").value;
  validateBudget();
}
function onChangeMealKind() { inputMealKind = document.getElementById("meal-kind").value }

function onSubmitSearchRestaurant(event) {
  event.preventDefault(); 

  $.ajax({
    type: 'POST',
    url: '/api/line/callback_liff',
    data: {
      line_liff: {
        location: inputLocation,
        meal_type: inputMealType,
        genre: inputMealKind,
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

