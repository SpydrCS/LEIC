@extends('layouts.app')

@section('title', 'Events')

@section('content')

<div class="everything">
    <h2 class="white-font">
        My Notifications
    </h2>
    <div class="notification-part">
        <div class="notification-options">
            <div class="notification-options-title">
                <button onclick="invis_notification(3)" class="pd0 not-btn" id="all-notifications">
                    All Notifications
                </button>
            </div>
            <div class="notification-options-title">
                <button onclick="invis_notification(1)" class="pd0 not-btn" id="sent-notifications">
                    Sent Notifications
                </button>
            </div>
            <div class="notification-options-title">
                <button onclick="invis_notification(2)" class="pd0 not-btn" id="received-notifications">
                    Received Notifications
                </button>
            </div>
            <div class="notification-options-title">
                <button onclick="invis_notification(4)" class="pd0 not-btn" id="join-requests">
                    Join Requests
                </button>
            </div>
            <div class="notification-options-title">
                <button onclick="invis_notification(5)" class="pd0 not-btn" id="event-invites">
                    Event Invites
                </button>
            </div>
        </div>
        <div class="all-notifications">
            @each('partials.notification', $notifications, 'notification')
        </div>
    </div>
</div>

@endsection