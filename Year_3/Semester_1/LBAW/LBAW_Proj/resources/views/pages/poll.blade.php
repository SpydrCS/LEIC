@extends('layouts.app')

@section('title', 'Events')

@section('content')

<button onclick="window.location.href='/event/{{ $poll->event_id }}'" class="return-event-btn">
    <i class="fas fa-chevron-circle-left"></i> Return to Event Page
</button>
<h2 class="white-font">
    Comments for: "{{$poll->poll_title}}"
</h2>
<p class="white-font mgl10">
    Total of {{ count($comments) }} comments
</p>
<div class="action-btns">
    <button onclick="showCreateComment()" class="btn btn-primary crt-cmt-btn new-font no-margin" id="create-comment-button">Create Comment</button>
    <form method="POST" action="{{ route('addPollFile', $poll->id) }}" enctype="multipart/form-data" class="mgl50 add-poll-file">
        {{ csrf_field() }}
        <label for="poll_file" class="btn btn-primary crt-cmt-btn new-font no-margin file-inpt white-font">
            <i class="fas fa-plus-circle white-font mgr10"></i> Add File (*)
        </label>
        <input type="file" name="poll_file" id="poll_file" class="file-input">
        <button type="submit" class="btn btn-primary crt-cmt-btn new-font no-margin mgl10">Confirm</button>
    </form>
    <form method="POST" action="{{ route('downloadZip', $poll->id) }}" enctype="multipart/form-data" class="mgl50 add-poll-file">
        {{ csrf_field() }}
        <button type="submit" class="btn btn-primary crt-cmt-btn new-font no-margin mgl10">Get All Files</button>
    </form>
</div>
<div class="crt-comment mgr10" id="create-comment">
    <form method="POST" action="{{ route('createComment', $poll->id) }}" class="mgb10 crt-cmt-form">
        {{ csrf_field() }}
        <input type="hidden" name="poll_id" value="{{ $poll->id }}">
        <textarea name="comment" class="comment-textarea white-font no-margin" placeholder="Write your comment here..."></textarea>
        <button type="submit" class="btn btn-primary crt-cmt-btn new-font no-margin">Submit</button>
    </form>
</div>
<div class="all-comments new-font">
    @foreach ($comments as $comment)
    <div class="specific-comment mgr10 mgb10 white-font" id="comment-{{ $comment->id }}">
        @if ($comment->user->id == Auth::user()->id)
        <div class="comment-actions">
            <button onclick="deleteComment({{ $comment->id }})" class="edit-comment">Delete</button>
            <button onclick="showEditComment({{ $comment->id }})" class="edit-comment">Edit</button>
        </div>
        @endif
        <div class="comment-content">
            <p id="comment-content-{{$comment->id}}">
                {{ $comment->content }}
            </p>
            <form method="POST" action="{{ route('updateComment', $comment->id) }}" id="edit-comment-{{$comment->id}}">
                {{ csrf_field() }}
                <input type="hidden" name="comment_id" value="{{ $comment->id }}">
                <textarea name="comment" class="comment-textarea white-font no-margin" placeholder="Write your comment here...">{{ $comment->content }}</textarea>
                <button type="submit" class="btn btn-primary crt-cmt-btn new-font no-margin">Submit</button>
            </form>
        </div>
        <p class="comment-author">
            {{ $comment->user->name }}
        </p>
        <div class="ratings">
            <a class="white-font" onclick="addLike({{$comment->id}})" href="#">
                <span id="{{$comment->id}}-likes">
                    <i class="fas fa-thumbs-up"></i> {{ $comment->likes }}
                </span>
            </a>
             | 
            <a class="white-font" onclick="addDislike({{$comment->id}})" href="#">
                <span id="{{$comment->id}}-dislikes">
                    <i class="fas fa-thumbs-down"></i> {{ $comment->dislikes }}
                </span>
            </a>
        </div>
    </div>
    @endforeach
</div>

@endsection