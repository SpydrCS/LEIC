<div class="specific-event black-font">
    <a href="/event/{{ $attendee->event->id }}" class="something">
        <div class="specific-event-name"> 
            {{ $attendee->event->name }}
        </div>
    </a>
    <a href="/images/ticket.pdf" class="delete-event event-ticket" download>
        <i class="fas fa-ticket-alt white-font"></i>
    </a>
    <form method="POST" action="{{ route('leaveEvent', ['event_id' => $attendee->event->id, 'users_id' => $attendee->users_id]) }}">
        {{ csrf_field() }}
        <button type="submit" class="delete-event no-margin">
            <i class="fas fa-sign-out-alt"></i>
        </button>
    </form>
</div>