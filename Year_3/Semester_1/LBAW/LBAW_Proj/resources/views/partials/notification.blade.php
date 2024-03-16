@if ($notification->sent_users_id == Auth::user()->id) <!-- If the user is the sender -->
    <div class="singular-notification sent-not">
        <div class="sing-notification-title black-font">
            <a href="/event/{{ $notification->event->id }}">
                @if ($notification->event->owner_id == Auth::user()->id)
                    {{ $notification->event->name }} (Your event)
                @else
                    {{ $notification->event->name }}
                @endif
            </a>
        </div>
        <div>
            <span class="black-font pdl5">
                Sent by: You
            </span>
            <p class="black-font no-margin">
                To: <a href="/users/{{ $notification->receiver_user->id }}" class="white-font">{{ $notification->receiver_user->name }}</a>
            </p>
        </div>
        @if ($notification->status == 'pending')
            <span class="orange-font">
                {{ ucfirst($notification->status) }}
            </span>
            <form method="POST" action="{{ route('deleteNotification', $notification->id) }}" class="no-margin delete-sent-not">
                {{ csrf_field() }}
                <button type="submit" class="no-margin red-bg no-border accept-req-btn">Delete</button>
            </form>
        @elseif ($notification->status == 'accepted')
            <span class="green-font">
                {{ ucfirst($notification->status) }}
            </span>
        @elseif ($notification->status == 'rejected')
            <span class="red-font">
                {{ ucfirst($notification->status) }}
            </span>
        @endif
    </div>
@else <!-- If the user is the receiver -->
    @if ($notification->event->owner_id == Auth::user()->id)
    <div class="singular-notification received-owner-not">
    @else
    <div class="singular-notification received-not">
    @endif
        <div class="sing-notification-title black-font">
            <a href="/event/{{ $notification->event->id }}">
                @if ($notification->event->owner_id == Auth::user()->id)
                    {{ $notification->event->name }} (Your event)
                @else
                    {{ $notification->event->name }}
                @endif
            </a>
            <div class="not-info">
                <span class="black-font">
                    Sent by: <a href="/users/{{ $notification->sent_user->id }}" class="white-font">{{ $notification->sent_user->name }}</a>
                </span>
                <p class="black-font no-margin">
                    To: You
                </p>
            </div>
        </div>
        <div class="not-options">
        @if ($notification->status == 'pending' && $notification->event->owner_id == Auth::user()->id)
            <span class="orange-font">
                {{ ucfirst($notification->status) }}
            </span>
            <div class="accept-rej">
                <div class="accept-req">
                    <form method="POST" action="{{ route('acceptNotification', $notification->id) }}" class="no-margin mgi10">
                        {{ csrf_field() }}
                        <button type="submit" class="no-margin red-bg no-border accept-req-btn">Accept</button>
                    </form>
                </div>
                <div class="reject-req">
                    <form method="POST" action="{{ route('rejectNotification', $notification->id) }}" class="no-margin">
                        {{ csrf_field() }}
                        <button type="submit" class="no-margin red-bg no-border reject-req-btn">Reject</button>
                    </form>
                </div>
            </div>
        @elseif ($notification->status == 'pending')
            <span class="orange-font">
                {{ ucfirst($notification->status) }}
            </span>
            <div class="accept-rej">
                <div class="accept-req">
                    <form method="POST" action="{{ route('acceptInvite', $notification->id) }}" class="no-margin mgi10">
                        {{ csrf_field() }}
                        <button type="submit" class="no-margin red-bg no-border accept-req-btn">Accept</button>
                    </form>
                </div>
                <div class="reject-req">
                    <form method="POST" action="{{ route('rejectInvite', $notification->id) }}" class="no-margin">
                        {{ csrf_field() }}
                        <button type="submit" class="no-margin red-bg no-border reject-req-btn">Reject</button>
                    </form>
                </div>
            </div>
        @elseif ($notification->status == 'accepted')
            <span class="green-font">
                {{ ucfirst($notification->status) }}
            </span>
        @elseif ($notification->status == 'declined')
            <span class="red-font">
                {{ ucfirst($notification->status) }}
            </span>
        @endif
        </div>
    </div>
@endif