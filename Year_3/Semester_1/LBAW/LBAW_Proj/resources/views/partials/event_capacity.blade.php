<?php if ($event->max_capacity == $event->attendee_counter): ?>
    <p class="event-capacity red-font">
        Capacity: {{ $event->attendee_counter }} / {{ $event->max_capacity }}
    </p>

<?php elseif ($event->max_capacity - $event->attendee_counter < 50): ?>
    <p class="event-capacity orange-font">
        Capacity: {{ $event->attendee_counter }} / {{ $event->max_capacity }}
    </p>

<?php else: ?>
    <p class="event-capacity green-font">
        Capacity: {{ $event->attendee_counter }} / {{ $event->max_capacity }}
    </p>

<?php endif ?>