<div class="update-img" id="update-img-form">
  <div class="exit-form">
    <a onclick="lessOpa()" class="exit-form-button"><i class="fas fa-times white-font"></i></a>
  </div>
  <form method="POST" action="{{ route('updateProfileImage', $profile->id) }}" enctype="multipart/form-data">
    {{ csrf_field() }}
    <label for="image" class="white-font">New Profile Image (*)</label>
    <input id="image" type="file" name="image" class="white-font" accept="image/jpeg, image/png" required autofocus>
    <button type="submit" class="confirm-button update-img-btn">
        Confirm Update Profile Image
    </button>
  </form>
</div>

<div class="sing-profile" data-id="{{ $profile->id }}">
  <div class="profile-info">
    <div class="prof-img">
      @if (file_exists('storage/images/' . $profile->image))
        <img src="{{ asset('storage/images/' . $profile->image)}}" alt="Profile Image" class="white-font" width="200" height="200">
      @else
        <img src="{{ asset('images/profile_default.jpeg')}}" alt="Profile Image" class="white-font" width="200" height="200">
      @endif
      <a onclick="lessOpa()" class="update-profile-img"><i class="fas fa-pencil-alt pencil-edit"></i></a>
    </div>
    <div class="profile-information pdl1em">
      <div class="personal-info">
        <span class="personal-info-title">
          Personal Information:
        </span>
        <a class="edit-pencil" href="/update_profile/{{ $profile->id }}"> <i class="fas fa-pencil-alt pencil-edit"></i> </a> 
        <button class="delete-profile delete-event" onclick="deleteAccount()"> <i class="fas fa-trash"></i> </button>
        <form method="POST" action="{{ route('deleteAccount', $profile->id) }}">
          {{ csrf_field() }}
          <button type="submit" id="invis" class="edit-pencil confirm-button">
              Confirm Delete Account
          </button>
        </form>
        <div class="personal-info-list">
          <p>Name: <?php echo ucfirst($profile->name) ?> </p>
          <p>Email: {{ $profile->email }}</p>
          <p>Gender: <?php echo ucfirst($profile->gender) ?> </p>
          <p>Date of Birth: <?php echo substr($profile->date_of_birth,0,10) ?> </p>
          <p>Nationality: <?php echo ucfirst($profile->nationality) ?> </p>
          @if ($profile->is_admin && Auth::user()->is_admin)
            <p class="green-font">Admin: Yes</p>
          @elseif (!$profile->is_admin && Auth::user()->is_admin)
            <p id="balance-{{ $profile->id }}">Balance: €{{ $profile->wallet_balance }}</p>
            <p class="red-font">Admin: No</p>
          @endif
        </div>
      </div>
    </div>
  </div>
  @if (!$profile->is_admin)
  <div class="notifications">
    <div class="your-all">
      <div class="notification-title">
        <a href="{{ route('userNotifications', $profile->id) }}">
          My Notifications
        </a>
      </div>
      <div class="notification-title mgt10">
        <a href="{{ route('userComments', $profile->id) }}">
          My Comments
        </a>
      </div>
      <div class="notification-title mgt10">
        <a href="{{ route('userReports', $profile->id) }}">
          My Reports
        </a>
      </div>
      <div class="notification-title mgt10">
        <a href="{{ route('userFavorites', $profile->id) }}">
          My Favorites
        </a>
      </div>
    </div>
    @if (Auth::user()->is_admin)
    <div class="add-funds">
      <label for="funds" class="white-font">Add Funds</label>
      <input id="funds" class="white-font" type="number" name="funds" value="{{ old('wallet_balance') }}" required autofocus onchange="addFunds(value, {{ $profile->id }})">
    </div>
    @endif
  </div>
  @else
  <div class="notifications">
    <div class="your-all">
      <div class="notification-title">
        <a href=" {{ route('allReports') }}">
          All Reports
        </a>
      </div>
      <div class="notification-title mgt10">
        <a href=" {{ route('allEvents') }}">
          All Events
        </a>
      </div>
      <div class="notification-title mgt10">
        <a href=" {{ route('allUsers') }}">
          All Users
        </a>
      </div>
      <div class="notification-title mgt10">
        <a href=" {{ route('allPolls') }}">
          All Polls
        </a>
      </div>
    </div>
  </div>
  @endif
</div>
