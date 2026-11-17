from faster_whisper import WhisperModel
WhisperModel("small", device="cpu", compute_type="int8")
print("whisper small en cache")
