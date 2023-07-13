function addEventListeners() {
  let message = document.querySelector('.status-messages');
  let all = document.querySelectorAll("#content div:not(.status-messages)");
  if (message != null) {
    document.addEventListener("click", function(event) {
      if (event.target.closest(".status-messages")) {
        return;
      }
      if (message.style.display == "block") {
        message.style.display = "none";
        for (let i = 0; i < all.length; i++) {
          all[i].style.opacity = "1";
        }
      }
    })
  }

  let report = document.querySelector('#report-status');
  let all2 = document.querySelectorAll("#content div:not(#report-status)");
  if (report != null) {
    document.addEventListener("click", function(event) {
      if (event.target.closest("#report-status")) {
        return;
      }
      if (report.style.display == "block") {
        report.style.display = "none";
        for (let i = 0; i < all2.length; i++) {
          all2[i].style.opacity = "1";
        }
      }
    })
  }
}

function deleteAccount() {
  let invis_button = document.getElementById('invis');
  invis_button.style.display = 'block';
}

function deleteEventButton() {
  let invisi_button = document.getElementById('invisi');
  invisi_button.style.display = 'block';
}

function addScroll() {
  var mydiv = document.querySelectorAll('.event-features');
  var my_other_div = document.querySelector('.ovflw');
  if (mydiv == null || my_other_div == null) {
    return;
  }
  for (var i = 0; i <= mydiv.length -1 ; i++) {
    var scrollHeight = mydiv[i].scrollHeight;
    if (scrollHeight > 200) 
    {
      mydiv[i].style.overflow = 'scroll!important';
      my_other_div.style.overflow = 'scroll!important';
    }
  }
}

function setCorrectPadding() {
  var width_right = document.getElementById('personal-events').offsetWidth;
  var width_left = document.getElementById('my-events').offsetWidth;
  var width_window = screen.width;

  document.getElementById('personal-events').style.paddingLeft = width_window - (width_left - 20 + width_right) + 'px';
}

function invis_notification(option) {
  const sent_divs = document.getElementsByClassName("singular-notification sent-not");
  for (let i = 0; i < sent_divs.length; i++) {
    sent_divs[i].style.display = 'none';
  }
  const received_divs = document.getElementsByClassName("singular-notification received-not");
  for(var i=0; i<received_divs.length; i++) { 
    received_divs[i].style.display = 'none';
  }
  const received_owner_divs = document.getElementsByClassName("singular-notification received-owner-not");
  for(var i=0; i<received_owner_divs.length; i++) { 
    received_owner_divs[i].style.display = 'none';
  }

  const all_nots_btn = document.getElementById("all-notifications");
  const sent_nots_btn = document.getElementById("sent-notifications");
  const received_nots_btn = document.getElementById("received-notifications");
  const join_request_btn = document.getElementById("join-requests");
  const event_invites_btn = document.getElementById("event-invites");

  const btns = [all_nots_btn, sent_nots_btn, received_nots_btn, join_request_btn, event_invites_btn];

  for (let i = 0; i < btns.length; i++) {
    btns[i].style.color = "white";
  }

  if (option == 1) {
    for (let i = 0; i < sent_divs.length; i++) {
      sent_divs[i].style.display = 'block';
    }
    sent_nots_btn.style.color = "#c3073f";
  }
  else if (option == 2) {
    for (let i = 0; i < received_divs.length; i++) {
      received_divs[i].style.display = 'block';
    }
    for (let i = 0; i < received_owner_divs.length; i++) {
      received_owner_divs[i].style.display = 'block';
    }
    received_nots_btn.style.color = "#c3073f";
  }
  else if (option == 3) {
    for (let i = 0; i < received_divs.length; i++) {
      received_divs[i].style.display = 'block';
    }
    for (let i = 0; i < sent_divs.length; i++) {
      sent_divs[i].style.display = 'block';
    }
    for (let i = 0; i < received_owner_divs.length; i++) {
      received_owner_divs[i].style.display = 'block';
    }
    all_nots_btn.style.color = "#c3073f";
  }
  else if (option == 4) {
    for (let i = 0; i < received_owner_divs.length; i++) {
      if (received_owner_divs[i].textContent.includes('pending')) {
        received_owner_divs[i].style.display = 'block';
      }
    }
    join_request_btn.style.color = "#c3073f";
  }
  else if (option == 5) {
    console.log("Received inside: " + received_divs.length);
    for (let i = 0; i < received_divs.length; i++) {
      if (received_divs[i].textContent.includes('pending')) {
        received_divs[i].style.display = 'block';
      }
    }
    event_invites_btn.style.color = "#c3073f";
  }
}

function showEvents(option) {
  const public_events = document.getElementsByClassName("event publics");
  for (let i = 0; i < public_events.length; i++) {
    public_events[i].style.display = 'none';
  }
  const private_events = document.getElementsByClassName("event privates");
  for(var i=0; i<private_events.length; i++) { 
    private_events[i].style.display = 'none';
  }

  if (option == "all") {
    for (let i = 0; i < public_events.length; i++) {
      public_events[i].style.display = 'block';
    }
    for (let i = 0; i < private_events.length; i++) {
      private_events[i].style.display = 'block';
    }
  }
  else {
    const show_events = document.getElementsByClassName("event " + option + "s");
    for (let i = 0; i < show_events.length; i++) {
      show_events[i].style.display = 'block';
    }
  }
}

function showTags(option) {
  const all_tags = document.getElementsByClassName("event");
  for (let i = 0; i < all_tags.length; i++) {
    all_tags[i].style.display = 'none';
  }

  if (option == "all") {
    for (let i = 0; i < all_tags.length; i++) {
      all_tags[i].style.display = 'block';
    }
  }
  else {
    const tags = document.getElementsByClassName(option);
    for (let i = 0; i < tags.length; i++) {
      tags[i].style.display = 'block';
    }
  }
}

function showLocations(option) {
  const all_locations = document.getElementsByClassName("event");
  for (let i = 0; i < all_locations.length; i++) {
    all_locations[i].style.display = 'none';
  }

  if (option == "all") {
    for (let i = 0; i < all_locations.length; i++) {
      all_locations[i].style.display = 'block';
    }
  }
  else {
    const locations = document.getElementsByClassName(option);
    for (let i = 0; i < locations.length; i++) {
      locations[i].style.display = 'block';
    }
  }
}

function showName(option) {
  const all_events = document.getElementsByClassName("event");
  const no_events = document.getElementById("no-events");
  no_events.style.display = 'none';
  for (let i = 0; i < all_events.length; i++) {
    all_events[i].style.display = 'none';
  }
  if (option == "") {
    for (let i = 0; i < all_events.length; i++) {
      all_events[i].style.display = 'block';
    }
  }
  else {
    const names = document.getElementsByClassName(option);
    if (names.length == 0) {
      no_events.style.display = 'block';
    }
    for (let i = 0; i < names.length; i++) {
      names[i].style.display = 'block';
    }
  }
}

function showFAQ(option, num) {
  let about = document.getElementById(option);
  let about_title = document.getElementById(option + "-title");
  if (about.style.display == "none") {
    about.style.display = "block";
    if (num == 1) {
      about_title.innerHTML = "<i class='fas fa-angle-down'></i> ABOUT POWEREVENTS"
    }
    else if (num == 2) {
      about_title.innerHTML = "<i class='fas fa-angle-down'></i> REGISTRATION"
    }
    else if (num == 3) {
      about_title.innerHTML = "<i class='fas fa-angle-down'></i> CANCELLATIONS"
    }
  }
  else {
    about.style.display = "none";
    if (num == 1) {
      about_title.innerHTML = "<i class='fas fa-angle-right'></i> ABOUT POWEREVENTS"
    }
    else if (num == 2) {
      about_title.innerHTML = "<i class='fas fa-angle-right'></i> REGISTRATION"
    }
    else if (num == 3) {
      about_title.innerHTML = "<i class='fas fa-angle-right'></i> CANCELLATIONS"
    }
  }
}

function showCreateComment() {
  let comment = document.getElementById("create-comment");
  let button = document.getElementById("create-comment-button");
  if (comment.style.display == "none") {
    comment.style.display = "block";
    button.innerHTML = "Hide Create Comment";
  }
  else {
    comment.style.display = "none";
    button.innerHTML = "Create Comment";
  }
}

function showCreatePoll() {
  let poll = document.getElementById("crt-poll-form");
  let button = document.getElementById("show-crt-form");
  if (poll.style.display == "none") {
    poll.style.display = "block";
    button.innerHTML = "-";
  }
  else {
    poll.style.display = "none";
    button.innerHTML = "+";
  }
}

function showEditComment(id) {
  let comment = document.getElementById("edit-comment-" + id);
  let content = document.getElementById("comment-content-" + id);
  if (comment.style.display == "none") {
    comment.style.display = "block";
    content.style.display = "none";
  }
  else {
    comment.style.display = "none";
    content.style.display = "block";
  }
}

function changeWallet(balance, id) {
  document.getElementById("balance-" + id).innerHTML = "Wallet Balance: €" + balance;
  if (document.querySelector("#header-balance-" + id) != null) {
    document.getElementById("header-balance-" + id).innerHTML = "€" + balance;
  }
}

function changeRating(id, rating, option) { // option = 1 for like, 2 for dislike
  if (option == 1) {
    document.getElementById(id + "-likes").innerHTML = "<i class='fas fa-thumbs-up'></i> " + rating;
  }
  else if (option == 2) {
    document.getElementById(id + "-dislikes").innerHTML = "<i class='fas fa-thumbs-down'></i> " + rating;
  }
}

function removeUser(id) {
  let user = document.getElementById("user-" + id);
  user.style.display = "none";
}

function removeEvent(id) {
  let event = document.getElementById("event-" + id);
  event.style.display = "none";
}

function removeReport(id) {
  let report = document.getElementById("report-" + id);
  report.style.display = "none";
}

function removeFavorite(id) {
  let favorite = document.getElementById("favorite-" + id);
  favorite.style.display = "none";
}

function removeComment(id) {
  let comment = document.getElementById("comment-" + id);
  comment.style.display = "none";
}

function editPoll(id) {
  let poll = document.getElementById("poll-title-" + id);
  let edit = document.getElementById("update-poll-" + id);
  if (poll.style.display == "none") {
    poll.style.display = "block";
    edit.style.display = "none";
  }
  else {
    poll.style.display = "none";
    edit.style.display = "block";
  }
}

function showJoinEvent(option, msg = "null") {
  let all = document.querySelectorAll("#content div:not(.status-messages)");
  let sect = document.getElementById("status-messages");
  let accept = document.getElementById("accepted-msg");
  let reject = document.getElementById("rejected-msg");
  sect.style.display = "block";
  accept.style.display = "none";
  reject.style.display = "none";

  for (let i = 0; i < all.length; i++) {
    all[i].style.opacity = "0.5";
  }

  if (option < 100) { // accepted action
    accept.style.display = "block";
    if (option == 1) {
      accept.innerHTML = 'You have successfully joined this event!';
    }
    else if (option == 2) {
      accept.innerHTML = 'You have successfully requested to join this event!';
    }
    else if (option == 3) {
      accept.innerHTML = 'You have successfully invited this user to your event!';
    }
    else if (option == 30) {
      accept.innerHTML = msg;
    }
  }
  
  else { // rejected action
    reject.style.display = "block";
    if (option == 101) {
      reject.innerHTML = 'You do not have enough money to join this event!';
    }
    else if (option == 102) {
      reject.innerHTML = 'You are already attending this event!';
    }
    else if (option == 103) {
      reject.innerHTML = 'You have already requested to join this event!';
    }
    else if (option == 130) {
      reject.innerHTML = msg;
    }
  }
}

function showEditFeature(id) {
  let feature_title = document.getElementById("feature-title-" + id);
  let edit_feature_form = document.getElementById("update-feature-" + id);
  if (feature_title.style.display == "none") {
    feature_title.style.display = "block";
    edit_feature_form.style.display = "none";
  }
  else {
    feature_title.style.display = "none";
    edit_feature_form.style.display = "block";
  }
}

function showReportStatus(option) {
  let all = document.querySelectorAll("#content div:not(.report-status)");
  let sect = document.getElementById("report-status");
  let accept = document.getElementById("accepted-report");
  let reject = document.getElementById("rejected-report");
  sect.style.display = "block";
  accept.style.display = "none";
  reject.style.display = "none";
  for (let i = 0; i < all.length; i++) {
    all[i].style.opacity = "0.5";
  }
  sect.style.opacity = "1";
  if (option == 1) {
    accept.style.display = "block";
    accept.innerHTML = 'You have successfully reported this event!';
  }
  else if (option == 2) {
    reject.style.display = "block";
    reject.innerHTML = 'You have already reported this event!';
  }
  else if (option == 3) {
    accept.style.display = "block";
    accept.innerHTML = 'You have successfully invited your friend!';
  }
  else if (option == 4) {
    reject.style.display = "block";
    reject.innerHTML = 'You have already this friend to this event!';
  }
}

function showReportForm() {
  let report_form = document.getElementById("report-form");
  let report_button = document.getElementById("report-button");
  let invite_friend_button = document.getElementById("invite-button");
  if (report_form.style.display == "none") {
    report_form.style.display = "flex";
    report_button.innerHTML = "Hide Report Form";
    invite_friend_button.style.display = "none";
  }
  else {
    report_form.style.display = "none";
    report_button.innerHTML = "<i class='fas fa-flag white-font'></i> Report Event";
    invite_friend_button.style.display = "block";
  }
}

function showInviteForm() {
  let invite_form = document.getElementById("invite-form");
  let report_button = document.getElementById("report-button");
  let invite_friend_button = document.getElementById("invite-button");
  if (invite_form.style.display == "none") {
    invite_form.style.display = "flex";
    invite_friend_button.innerHTML = "Hide Invite Form";
    report_button.style.display = "none";
  }
  else {
    invite_form.style.display = "none";
    invite_friend_button.innerHTML = "<i class='fas fa-user-plus white-font'></i> Invite Friend";
    report_button.style.display = "block";
  }
}

function showEditReport(id) {
  let form = document.getElementById("edit-report-" + id);
  let description = document.getElementById("report-description-" + id);
  let edit_btn = document.getElementById("edit-report-btn-" + id);
  if (form.style.display == "none") {
    form.style.display = "flex";
    description.style.display = "none";
    edit_btn.innerHTML = "Cancel Edit";
  }
  else {
    form.style.display = "none";
    description.style.display = "block";
    edit_btn.innerHTML = "Edit";
  }
}

function lessOpa() {
  let form = document.getElementById("update-img-form");
  let all = document.querySelectorAll("#content div:not(.update-img)");
  if (form.style.display == "none") {
    form.style.display = "block";
    for (let i = 0; i < all.length; i++) {
      all[i].style.opacity = "0.5";
    }
    form.style.opacity = "1";
  }
  else {
    form.style.display = "none";
    for (let i = 0; i < all.length; i++) {
      all[i].style.opacity = "1";
    }
  }
}

function showFavorite(message, option) {
  let all = document.querySelectorAll("#content div:not(.status-messages)");
  let sect = document.getElementById("status-messages");
  let accept = document.getElementById("accepted-msg");
  let reject = document.getElementById("rejected-msg");
  sect.style.display = "block";
  accept.style.display = "none";
  reject.style.display = "none";
  for (let i = 0; i < all.length; i++) {
    all[i].style.opacity = "0.5";
  }
  if (option == 1) {
    accept.style.display = "block";
    accept.style.opacity = "1";
    accept.innerHTML = message;
  }
  else if (option == 2) {
    reject.style.display = "block";
    reject.style.opacity = "1";
    reject.innerHTML = message;
  }
}

function profileMenu(option) {
  let profile_info = document.getElementById("profile-info");
  let my_events = document.getElementById("my-events");
  let personal_events = document.getElementById("personal-events");
  profile_info.style.display = "none";
  my_events.style.display = "none";
  personal_events.style.display = "none";
  if (option == 1) {
    profile_info.style.display = "block";
  }
  else if (option == 2) {
    my_events.style.display = "block";
  }
  else if (option == 3) {
    personal_events.style.display = "flex";
  }
}

function redirectPage(option) {
  if (option == 1) {
    window.location.href = "/events/today";
  }
  else if (option == 2) {
    window.location.href ="/events/this_week";
  }
  else if (option == 3) {
    window.location.href = "/events/this_month";
  }
  else if (option == 4) {
    window.location.href = "/events/this_year";
  }
  else if (option == 5) {
    window.location.href = "/events/all";
  }
}

function showEventStatus(option, id) {
  let btn = document.getElementById("change-event-status-" + id);
  console.log("change-event-status-" + id);
  if (option == 1) { // open event
    btn.innerHTML = "<i class='fas fa-door-open white-font mgi5 mgb3'></i>";
  }
  else if (option == 2) { // close event
    btn.innerHTML = "<i class='fas fa-door-closed white-font mgi5 mgb3'></i>";
  }
}

//setCorrectPadding();

addScroll();

addEventListeners();
