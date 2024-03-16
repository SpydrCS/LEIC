@if ($event->is_private)
<article class="event privates {{ $event->tag }} {{ $event->name }} {{ ucfirst($event->location) }}" data-id="{{ $event->id }}" id="event-{{ $event->id }}">
@else
<article class="event publics {{ $event->tag }} {{ $event->name }} {{ ucfirst($event->location) }}" data-id="{{ $event->id }}" id="event-{{ $event->id }}">
@endif
  <header>
    <h2 class="event-name">
      <a href="/event/{{ $event->id }}">{{ $event->name }}</a>
    </h2>
  </header>
  <div class="event-info">
    <a href="/event/{{ $event->id }}">
      @if (file_exists('storage/images/' . $event->image))
      <img src="{{ asset('storage/images/' . $event->image)}}" alt="Event Image" class="white-font evt-img">
      @else
      <img src="{{ asset('images/events_default.jpg')}}" alt="Event Image" class="white-font evt-img">
      @endif
    </a>
    <p class="event-location white-font"> <i class="fas fa-map-marker-alt"></i> {{ ucfirst($event->location) }} </p>
    @if ($event->is_private)
    <p class="event-privacy white-font private"> <i class="fas fa-lock white-font"></i> Private </p>
    @else
    <p class="event-privacy white-font public"> <i class="fas fa-lock-open white-font"></i> Public </p>
    @endif
    <p class="event-date white-font no-margin" id="date-{{ $event->id}}"></p>
    @if (Auth::check())
    <div class="add-favorite">
      <button class="no-margin favorite-btn" onclick="addFavorite({{ $event->id }}, {{ Auth::user()->id }})"> <i class="fas fa-heart white-font"></i> </button>
    </div>
    @endif
  </div>
</article>
