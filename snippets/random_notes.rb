# default range avoids hard-to-hear notes
def random_note(low = 42, high = 110)
  rrand_i(low, high)
end

def random_chord_note
  chords = [chord(:E3, :major), chord(:A3, :major)]
  chords.flatten.choose
end

def random_chord
  chords = [chord(:E3, :major), chord(:A3, :major)]
  chords.choose
end
