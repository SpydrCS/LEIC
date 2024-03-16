@extends('layouts.app')

@section('title', 'Profile')

@section('content')

<h2 class="comments-title white-font mgl10">
    My Comments
</h2>

<div class="all-your-comments">
    @foreach ($comments as $comment)
    <div class="your-specific-comment white-font" id="comment-{{ $comment->id }}">
        <button onclick="deleteComment({{ $comment->id }})" class="edit-comment">Delete</button>
        <p class="no-margin">
            "{{ $comment->content }}"
        </p>
        <p class="no-margin">
            <u>{{ $comment->likes }}</u> likes and <u>{{ $comment->dislikes }}</u> dislikes
        </p>
        <p class="no-margin">
            In poll: <a href="/poll/{{ $comment->poll->id }}#{{ $comment->id }}">{{ $comment->poll->poll_title }}</a>
        </p>
    </div>
    @endforeach
</div>

@endsection