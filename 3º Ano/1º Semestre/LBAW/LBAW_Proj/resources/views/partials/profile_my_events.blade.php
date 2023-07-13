<div class="specific-event black-font">
    <a href="/event/{{ $event->id }}" class="specific-event-name"> 
        {{ $event->name }} 
    </a>
    @if (!$event->is_full)
        <button class="button mgt100 rgt bd" id="change-event-status-{{ $event->id }}" onclick="changeEventStatus({{ $event->id }})"> 
            <i class="fas fa-door-open white-font mgi5 mgb3"></i>
        </button>
    @else
        <button class="button mgt100 rgt bd" id="change-event-status-{{ $event->id }}" onclick="changeEventStatus({{ $event->id }})"> 
            <i class="fas fa-door-closed white-font mgi5 mgb3"></i>
        </button>
    @endif
    <a class="button mgt100 rgt bd" href="/event_statistics/{{ $event->id }}"> 
        <i class="fas fa-signal white-font mgi5 mgb3"></i> 
    </a>
    <a class="edit-pencil pdr5" href="/update_event/{{ $event->id }}"> 
        <i class="fas fa-pencil-alt pencil-edit"></i>
    </a> 
    <form method="POST" action="{{ route('deleteEvent', $event->id) }}">
    {{ csrf_field() }}
        <button type="submit" class="delete-event no-margin">
            <i class="fas fa-trash"></i>
        </button>
    </form> 
</div>