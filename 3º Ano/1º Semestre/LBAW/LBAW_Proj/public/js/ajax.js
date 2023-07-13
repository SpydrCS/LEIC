function encodeForAjax(data) {
    if (data == null) return null;
    return Object.keys(data).map(function(k){
      return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
    }).join('&');
  }

function listenEvents() {
    let report_form = document.querySelector('#report-form');
    if (report_form != null) {
        report_form.addEventListener("submit", function(event) {
            event.preventDefault();
            var event_id = document.getElementById('event_id').value;
            var user_id = document.getElementById('user_id').value;
            var description = document.getElementById('description').value;
            var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            var data = {
                event_id: event_id,
                user_id: user_id,
                description: description,
                token: token
            }
            reportEventAjax(data).catch(() => console.error('Network Error'))
            .then(response => response.json())
            .catch(() => console.error('Error parsing JSON'))
            .then(json => showReportStatus(json))
        })
    }
  
    let invite_attendee = document.querySelector('#invite-attendee');
    if (invite_attendee != null) {
        invite_attendee.addEventListener("submit", function(event) {
            event.preventDefault();
            var event_id = document.getElementById('event_id').value;
            var user_id = document.getElementById('user_id').value;
            var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            var data = {
                event_id: event_id,
                user_id: user_id,
                token: token
            }
            inviteAttendeeAjax(data).catch(() => console.error('Network Error'))
            .then(response => response.text())
            .catch(() => console.error('Error parsing JSON'))
            .then(function(json) {
                if (json.substr(0,10) == "You have a") {
                    showJoinEvent(130, json);
                }
                else {
                    showJoinEvent(30, json);
                }
            })
        })
    }

    let invite_form = document.querySelector('#invite-form');
    if (invite_form != null) {
        invite_form.addEventListener("submit", function(event) {
            event.preventDefault();
            var event_id = document.getElementById('event_id').value;
            var user_id = document.getElementById('user_id').value;
            var invite_id = document.getElementById('invite_id').value;
            var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            var data = {
                event_id: event_id,
                user_id: user_id,
                invite_id: invite_id,
                token: token
            }
            inviteFriendAjax(data).catch(() => console.error('Network Error'))
            .then(response => response.json())
            .catch(() => console.error('Error parsing JSON'))
            .then(json => showReportStatus(json))
        })
    }
}

// ------------------------------
// Ajax functions for event listeners

async function reportEventAjax(data) {
    return fetch('/reportEvent', {
    method: 'post',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-TOKEN': data['token']
    },
    body: encodeForAjax(data)
    })
}

async function inviteAttendeeAjax(data) {
    return fetch('/inviteEventAttendee', {
    method: 'post',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-TOKEN': data['token']
    },
    body: encodeForAjax(data)
    })
}

async function inviteFriendAjax(data) {
    return fetch('/inviteFriend', {
    method: 'post',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-TOKEN': data['token']
    },
    body: encodeForAjax(data)
    })
}

// ------------------------------
// Request to Join Private Event

function reqJoinEvt(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    reqJoinEvtAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => showJoinEvent(json))
}

async function reqJoinEvtAjax(data) {
    return fetch('/requestJoinEvent', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Join Public Event

function joinEvt(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    joinEvtAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => showJoinEvent(json))
}

async function joinEvtAjax(data) {
    return fetch('/joinEvent', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Delete Favorited Event

function deleteFavorite(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    deleteFavoriteAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => removeFavorite(json))
}

function deleteFavoriteAjax(data) {
    return fetch('/deleteFavorite', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Add Event to Favorites

function addFavorite(event_id, users_id) {
    data = {
        event_id: event_id,
        users_id: users_id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    addFavoriteAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.text())
    .catch(() => console.error('Error parsing JSON'))
    .then(function(json) {
        if (json.substr(0,1) == "T") {
            showFavorite(json, 2);
        }
        else {
            showFavorite(json, 1);
        }
    })
}

function addFavoriteAjax(data) {
    return fetch('/addFavorite', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Admin Delete User

function deleteUser(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    deleteUserAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => removeUser(json))
}

function deleteUserAjax(data) {
    return fetch('/adminDeleteUser', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Admin Delete Event

function deleteEvent(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    deleteEventAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => removeEvent(json))
}

function deleteEventAjax(data) {
    return fetch('/adminDeleteEvent', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Delete Report

function deleteReport(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    deleteReportAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => removeReport(json))
}

function deleteReportAjax(data) {
    return fetch('/deleteReport', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Delete Comment

function deleteComment(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    deleteCommentAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => removeComment(json))
}

function deleteCommentAjax(data) {
    return fetch('/deleteComment', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Add Funds

function addFunds(funds, id) {
    data = {
        funds: funds,
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    addFundsAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => changeWallet(json, id))
}

function addFundsAjax(data) {
    return fetch('/addFunds', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Update Event Privacy

function updatePrivacy(event_id) {
    var is_checked = document.getElementById("color_mode").checked;
    data = {
        is_checked: is_checked,
        event_id: event_id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    updatePrivacyAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.text())
    .catch(() => console.error('Error parsing JSON'))
}

function updatePrivacyAjax(data) {
    return fetch('/updateEventPrivacy', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    })
}

// ------------------------------
// Add Like

function addLike(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    addLikeAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.text())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => changeRating(id, json, 1));
}

function addLikeAjax(data) {
    return fetch('/addLikes', {
        method: 'POST',
        headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    });
}

// ------------------------------
// Add Dislike

function addDislike(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    addDislikeAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.text())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => changeRating(id, json, 2));
}

function addDislikeAjax(data) {
    return fetch('/addDislikes', {
        method: 'POST',
        headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    });
}

// ------------------------------
// Close Event

function changeEventStatus(id) {
    data = {
        id: id,
        token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
    changeEventStatusAjax(data).catch(() => console.error('Network Error'))
    .then(response => response.json())
    .catch(() => console.error('Error parsing JSON'))
    .then(json => showEventStatus(json, id));
}

function changeEventStatusAjax(data) {
    return fetch('/changeEventStatus', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': data['token']
        },
        body: encodeForAjax(data)
    });
}

// ------------------------------

listenEvents();