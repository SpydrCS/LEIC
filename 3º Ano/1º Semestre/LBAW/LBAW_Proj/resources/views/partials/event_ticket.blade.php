@if ($event->is_full)
    <div class="mgt50 evt-full">
        <h3 class=""> <i class="fas fa-exclamation-circle pdr10"></i>Event Closed</h3>
    </div>
@elseif ($event->attendee_counter < $event->max_capacity && $event->start_datetime > date('Y-m-d H:i:s'))
    @if ($event->is_private == 0)
        <div class="join-evt-btn-div">
            <a class="button mgt100 join-evt-btn" onclick="joinEvt({{ $event->id }})"> Confirm Choice </a>
        </div>
    @elseif ($event->is_private == 1)
    <div class="join-evt-btn-div">
            <a class="button mgt100 join-evt-btn" onclick="reqJoinEvt({{ $event->id }})" id="req-join-event"> Request to Join Event </a>
        </div>
    @endif
@elseif ($event->attendee_counter >= $event->max_capacity)
    <div class="mgt50 evt-full">
        <h3 class=""> <i class="fas fa-exclamation-circle pdr10"></i>Event Full</h3>
    </div>
@else
    <div class="mgt50 evt-started">
        <h3 class=""> <i class="fas fa-exclamation-circle pdr10"></i>Event Started </h3>
    </div>
@endif