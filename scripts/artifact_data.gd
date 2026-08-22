class_name ArtifactData

# A bundle of evidence that renders as a single artifact. Each artifact type grabs
# its own pieces from the pool (see Artifact.select_evidence).
var evidence: Array[Evidence] = []
var artifact_scene: PackedScene # which document type renders this artifact
var misc_data := {} # shared per-artifact data, e.g. the eyewitness name
