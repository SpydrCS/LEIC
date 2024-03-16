<?php if (Auth::check() && Auth::user()->id == $event->owner_id) { ?>
    <a href="{{ route('manageParticipants', $event->id) }}" class="add-feature">
        <div class="add-feature-icon">
            <i class="fas fa-tasks"></i>
        </div>
    </a>
    <a href="{{ route('inviteAttendee', $event->id) }}" class="add-feature">
        <div class="add-feature-icon">
            +
        </div>
    </a>
<?php } ?>