<article class="sing-event" data-id="{{ $event->id }}">
  <header class="event-header">
    <h2 class="event-name fsbb">
      {{ $event->name }}
    </h2>
    @if (Auth::check())
      @if (Auth::user()->id == $event->owner_id || Auth::user()->is_admin)
      <div class="event-statistics">
        <a class="button mgt100 rgt" href="/event_statistics/{{ $event->id }}">Event Statistics</a>
      </div>
      <div class="edit-evt-div-page">
        <a class="edit-btn edit-evt-btn-page" href="/update_event/{{ $event->id }}">
          <i class="fas fa-edit white-font"></i>
        </a>
      </div>
      <div class="btn-container" id="smth-new">
        <label class="switch btn-color-mode-switch">
          @if ($event->is_private)
          <input type="checkbox" name="color_mode" id="color_mode" value="1" onchange="updatePrivacy({{ $event->id }})" checked>
          @else
          <input type="checkbox" name="color_mode" id="color_mode" value="1" onchange="updatePrivacy({{ $event->id }})">
          @endif
          <label for="color_mode" data-on="Private" data-off="Public" class="btn-color-mode-switch-inner"></label>
        </label>
      </div>
      @else
      <div class="report-container">
        <button onclick="showReportForm()" class="report-btn mgi10" id="report-button">
          <i class="fas fa-flag white-font"></i> Report Event
        </button>
        <form class="white-font" id="report-form">
          <input id="description" type="text" name="description" value="" class="report-textarea white-font" placeholder="Write a report..."   required>
          @if ($errors->has('description'))
            <span class="error">
                {{ $errors->first('description') }}
            </span>
          @endif

          <input type="hidden" name="event_id" id="event_id" value="{{ $event->id }}">
          <input type="hidden" name="user_id" id="user_id" value="{{ Auth::user()->id }}">

          <button type="submit" class="report-btn mgl10">
            Confirm
          </button>
        </form>
      </div>
      <div class="report-container">
        <button onclick="showInviteForm()" class="report-btn mgi10" id="invite-button">
          <i class="fas fa-user-plus white-font"></i> Invite Friend
        </button>
        <form class="white-font" id="invite-form">
          <input id="invite_id" type="text" name="invite_id" value="" class="invite-textarea white-font" placeholder="Write a friend's ID..."   required>
          @if ($errors->has('email'))
            <span class="error">
                {{ $errors->first('email') }}
            </span>
          @endif

          <input type="hidden" name="event_id" id="event_id" value="{{ $event->id }}">
          <input type="hidden" name="user_id" id="user_id" value="{{ Auth::user()->id }}">

          <button type="submit" class="report-btn mgl10">
            Confirm
          </button>
        </form>
      </div>
      @endif
    @endif
  </header>
  <p class="event-description pdl1em">
    {{ $event->description }}
  </p>
</article>