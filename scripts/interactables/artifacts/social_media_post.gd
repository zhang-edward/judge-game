class_name SocialMediaPost
extends Artifact

@onready var name_label: Label = $ColorRect/Name
@onready var username_label: Label = $ColorRect/Username
@onready var post_body: RichTextLabel = $ColorRect/PostBody
@onready var post_stats: RichTextLabel = $ColorRect/PostStats
@onready var comments: Label = $ColorRect/Comments
@onready var likes: Label = $ColorRect/Likes
@onready var retweets: Label = $ColorRect/Retweets
@onready var bookmarks: Label = $ColorRect/Bookmarks

var s = "I'm $action a $item in the $location!"
var greetings = [
	"Hello everybody.",
	"Hi!",
	"Hey all!",
	"ATTENTION!",
	"Yo!"
]

func render_evidence_into_artifact(data: ArtifactData):
	var e = data.evidence.pick_random()
	name_label.text = e.suspect.name
	username_label.text = "@" + e.suspect.name.to_lower()
	var hashtags = []
	if e.action != null:
		s = s.replace("$action", e.action.gerund)
		hashtags.append("#" + e.action.gerund)
	else:
		s = s.replace("I'm $action", "I have")
	if e.item != null:
		s = s.replace("$item", e.item.name)
		hashtags.append("#" + e.item.name)
	else:
		s = s.replace(" a $item", " something")
	if e.location != null:
		s = s.replace("$location", e.location.id)
		hashtags.append("#" + e.location.id)
	else:
		s = s.replace(" in the $location", "")
	var final_s = greetings.pick_random() + " " + s
	hashtags.shuffle()
	var rand_hashtags = hashtags.slice(0, 2)
	final_s += " [color=#77B4F2]"  + " ".join(rand_hashtags) + "[/color]"
	post_body.text = final_s
	post_stats.text = str(e.time) + ":00 • Monday • [color=black]" + str(randi_range(0, 999)) + "[/color] views"
	likes.text = str(randi_range(0, 100))
	comments.text = str(randi_range(0, 10))
	bookmarks.text = str(randi_range(0, 100))
	retweets.text = str(randi_range(0, 100))
	
